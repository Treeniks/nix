{
  inputs,
  self,
  withSystem,
  ...
}:
let
  extraPackages =
    pkgs: with pkgs; [
      xwayland-satellite

      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
in
{
  flake.nixosModules.niri =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options = {
        my.niri = {
          extraIncludes = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
        };
      };

      config = {
        programs.xwayland.enable = true;
        programs.niri = {
          enable = true;
          package = inputs.wrappers.wrappers.niri.wrap {
            inherit pkgs;

            disableConfigValidation = true;
            extraSettings = [
              { include = "~/nix/modules/graphical/niri/common.kdl"; }
              { include = "~/nix/modules/graphical/niri/context/main.kdl"; }
            ]
            ++ (map (include: { inherit include; }) config.my.niri.extraIncludes)
            ++ (lib.optional config.my.noctalia-themeing {
              include = [
                { optional = true; }
                "~/.config/niri/noctalia.kdl"
              ];
            });
          };
        };
        environment.systemPackages = extraPackages pkgs;
      };
    };

  flake.wrappers.niri-greetd =
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

      settings = {
        spawn-sh-at-startup = [
          # config.wrapperPaths.placeholder should contain the path to the binary of the currently defined wrapper
          # we could probably just use pkgs.niri here and be fine, but that would also be scuff
          "${lib.getExe pkgs.regreet}; ${config.wrapperPaths.placeholder} msg action quit --skip-confirmation"
        ];
      };

      extraSettings = [
        { include = ./common.kdl; }
        { include = ./context/greetd.kdl; }
      ];
    };

  flake.wrappers.niri =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.niri ];

      extraPackages = extraPackages pkgs;

      extraSettings = [
        { include = ./common.kdl; }
        { include = ./context/main.kdl; }
      ];
    };

  # This one is an attempt to give a full desktop experience
  # as close as possible to my usual desktop.
  #
  # I don't use this directly because it would require
  # restarting niri when updating any package/config.
  # Instead, it's meant for when I'm on a foreign machine.
  #
  # Also, there are some hacks required to make sure my wrappers get prioritized
  # over the system-wide installed apps. These hacks are...not exactly pretty.
  flake.wrappers.niri-full =
    {
      pkgs,
      lib,
      wlib,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      selfPackages = self.packages.${system};
      fish = self.wrappers.fish.wrap {
        inherit pkgs;
        abbreviations = {
          nvim = lib.getExe selfPackages.neovim;
          mpv = lib.getExe selfPackages.mpv;
        };
      };
      kitty = self.wrappers.kitty.wrap {
        inherit pkgs;
        settings = {
          shell = lib.getExe fish;
          editor = lib.getExe selfPackages.neovim;
        };
      };
    in
    {
      imports = [ wlib.wrapperModules.niri ];

      extraPackages = extraPackages pkgs ++ [
        fish
        selfPackages.neovim
        selfPackages.mpv

        selfPackages.noctalia-shell
        selfPackages.fuzzel
        kitty

        pkgs.nemo
        pkgs.chameleos
      ];

      extraSettings = [
        { include = ./common.kdl; }
        {
          # we need to make sure the actual wrapped noctalia/fuzzel/kitty etc. are used
          # instead of ones that may be installed system-wide already
          include = "${pkgs.runCommand "main.kdl" { } ''
            cp ${./context/main.kdl} $out
            substituteInPlace $out --replace-fail '"noctalia-shell"' '"${lib.getExe selfPackages.noctalia-shell}"'
            substituteInPlace $out --replace-fail '"fuzzel"' '"${lib.getExe selfPackages.fuzzel}"'
            substituteInPlace $out --replace-fail '"kitty"' '"${lib.getExe kitty}"'
          ''}";
        }
        # in case the foreign machine has a strange monitor config
        # this allows one to change it on the fly
        {
          include = [
            { optional = true; }
            "~/.config/niri/output.kdl"
          ];
        }
      ];
    };
}
