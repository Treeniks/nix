{ self, ... }:
let
  themeName = "adw-gtk3";
  cursorThemeName = "catppuccin-mocha-maroon-cursors";
in
{
  den.aspects.greetdNiriReGreet.nixos =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      niriPackage = self.wrappers.niri-greetd.wrap {
        inherit pkgs;
        extraSettings = (map (include: { inherit include; }) config.my.greetd.niri.extraIncludes);
      };
    in
    {
      options = {
        my.greetd.niri = {
          extraIncludes = lib.mkOption {
            type = lib.types.listOf lib.types.path;
            default = [ ];
            description = ''
              Same as my.niri.extraIncludes except that it is used for greetd.
              Useful primarily because the greetd version should be a proper path,
              whereas we want hot reloading for the normal niri.
            '';
          };
        };
      };

      config = {
        environment.systemPackages = [
          pkgs.adw-gtk3
          pkgs.gammastep
        ];

        services.displayManager.regreet = {
          enable = true;
          theme.name = themeName;
          settings.GTK.application_prefer_dark_theme = true;
          cursorTheme.name = cursorThemeName;
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              # see also https://github.com/NixOS/nixpkgs/blob/1412caf7bf9e660f2f962917c14b1ea1c3bc695e/nixos/modules/programs/regreet.nix#L154
              command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe niriPackage}";
            };
          };
        };
      };
    };
}
