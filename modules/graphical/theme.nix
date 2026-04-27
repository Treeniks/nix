{ self, ... }:
let
  accentedCatppuccin =
    pkgs:
    (pkgs.magnetic-catppuccin-gtk.override {
      accent = [ "lavender" ];
    });

  iconThemeName = "Catppuccin-Mocha";
in
{
  flake.nixosModules.graphicalTheme =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (accentedCatppuccin pkgs)
        catppuccin-cursors.mochaLavender
        catppuccin-cursors.mochaMaroon
        self.packages.${pkgs.stdenv.hostPlatform.system}.fkorpsvart-catppuccin-icons

        adw-gtk3
        kdePackages.qt6ct
      ];

      programs.regreet = {
        theme.name = "Catppuccin-GTK-Lavender-Dark";
        cursorTheme.name = "catppuccin-mocha-maroon-cursors";
        iconTheme.name = iconThemeName;
      };
    };

  flake.homeModules.graphicalTheme =
    { config, pkgs, ... }:
    {
      catppuccin = {
        gtk.icon.enable = false;
        mangohud.enable = false;
        kvantum.enable = false;

        cursors.enable = true;
      };

      gtk = {
        enable = true;
        theme = {
          # the theme used by noctalia
          package = pkgs.adw-gtk3;
          name = "adw-gtk3";
        };
        colorScheme = "dark";

        iconTheme.name = iconThemeName;
        iconTheme.package = self.packages.${pkgs.stdenv.hostPlatform.system}.fkorpsvart-catppuccin-icons;

        # causes issues otherwise
        # gtk4.theme.name = "";

        # KDE loves replacing this file
        gtk2.force = true;
      };

      qt = {
        enable = true;
        qt6ctSettings = {
          Appearance = {
            style = "Breeze";
            custom_palette = true;
            standard_dialogs = "xdgdesktopportal";
            color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf";
          };
        };
      };
    };

  perSystem.wrappers.packages.noctalia-shell-gtk-qt = true;
  flake.wrappers.noctalia-shell-gtk-qt =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

      settings = {
        templates = {
          activeTemplates = [
            {
              id = "gtk";
              enabled = true;
            }
            {
              id = "qt";
              enabled = true;
            }
            {
              id = "kcolorscheme";
              enabled = true;
            }
          ];
        };
      };
    };
}
