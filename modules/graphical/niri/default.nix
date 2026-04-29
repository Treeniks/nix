{ inputs, ... }:
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
        environment.systemPackages = [
          (inputs.wrappers.wrappers.niri.wrap {
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
          })
        ];
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
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.niri ];

      extraSettings = [
        { include = ./common.kdl; }
        { include = ./context/main.kdl; }
      ];
    };
}
