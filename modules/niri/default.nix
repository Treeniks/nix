{ self, withSystem, ... }:
let
  extraPackages =
    pkgs:
    withSystem pkgs.stdenv.hostPlatform.system (
      { self', ... }:
      [
        self'.packages.noctalia-shell
        self'.packages.fuzzel
      ]
    );

  mkNiriWrappers = device: {
    "niri-${device}-greetd" =
      {
        config,
        pkgs,
        lib,
        wlib,
        ...
      }:
      {
        imports = [ wlib.wrapperModules.niri ];
        binName = "niri-greetd";

        "config.kdl".content =
          builtins.readFile ./common.kdl
          + builtins.readFile ./context/greetd.kdl
          + builtins.readFile ./device/${device}.kdl
          +
            # config.wrapperPaths.placeholder should contain the path to the binary of the currently defined wrapper
            # we could probably just use pkgs.niri here and be fine, but that would also be scuff
            ''
              spawn-sh-at-startup "${lib.getExe pkgs.regreet}; ${config.wrapperPaths.placeholder} msg action quit --skip-confirmation"
            '';
      };

    "niri-${device}-hot-reload" =
      { pkgs, wlib, ... }:
      {
        imports = [ wlib.wrapperModules.niri ];
        extraPackages = extraPackages pkgs;

        "config.kdl".content = ''
          include "/home/suteki/nix/modules/niri/common.kdl"
          include "/home/suteki/nix/modules/niri/context/main.kdl"
          include "/home/suteki/nix/modules/niri/device/${device}.kdl"
        '';

        disableConfigValidation = true;
      };

    "niri-${device}-standalone" =
      { pkgs, wlib, ... }:
      {
        imports = [ wlib.wrapperModules.niri ];
        extraPackages = extraPackages pkgs;

        "config.kdl".content =
          builtins.readFile ./common.kdl
          + builtins.readFile ./context/main.kdl
          + builtins.readFile ./device/${device}.kdl;
      };
  };
in
{
  # # module way:
  # options.niri.wrappers.devices = lib.mkOption {
  #   type = lib.types.listOf lib.types.str;
  #   default = [ ];
  # };
  # config.flake.wrappers = lib.mkMerge (map mkNiriWrappers config.niri.wrappers.devices);

  flake.wrappers = mkNiriWrappers "desktop" // mkNiriWrappers "asahi";

  flake.nixosModules.niri =
    { config, lib, ... }:
    {
      imports = [
        self.nixosModules.fuzzel
        self.nixosModules.noctalia-shell
      ];

      options = {
        niriPackage = lib.mkOption {
          type = lib.types.package;
        };
      };

      config = {
        environment.systemPackages = [
          config.niriPackage
        ];
      };
    };
}
