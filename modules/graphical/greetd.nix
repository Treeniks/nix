{
  flake.nixosModules.greetdNiriReGreet =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options = {
        greetd.niriPackage = lib.mkOption {
          type = lib.types.package;
          description = "The niri wrapper to use for the greetd session.";
        };
      };

      config = {
        programs.regreet.enable = true;

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              # see also https://github.com/NixOS/nixpkgs/blob/1412caf7bf9e660f2f962917c14b1ea1c3bc695e/nixos/modules/programs/regreet.nix#L154
              command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe config.greetd.niriPackage}";
            };
          };
        };

        environment.systemPackages = [
          pkgs.gammastep
        ];
      };
    };
}
