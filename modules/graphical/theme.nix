{ self, ... }:
let
  accentedCatppuccin =
    pkgs:
    (pkgs.magnetic-catppuccin-gtk.override {
      accent = [ "lavender" ];
    });

  iconThemeName = "Catppuccin-Mocha";
  cursorThemeName = "catppuccin-mocha-maroon-cursors";
  themeName = "Catppuccin-GTK-Lavender-Dark";
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
        theme.name = themeName;
        cursorTheme.name = cursorThemeName;
        iconTheme.name = iconThemeName;
      };
    };

  flake.homeModules.graphicalTheme =
    { config, pkgs, ... }:
    {
      catppuccin = {
        gtk.icon.enable = false;
        mangohud.enable = false;

        kvantum.enable = true;
        cursors.enable = true;
      };

      gtk = {
        enable = true;
        theme = {
          # the theme used by noctalia
          package = if config.my.noctalia-themeing then pkgs.adw-gtk3 else (accentedCatppuccin pkgs);
          name = if config.my.noctalia-themeing then "adw-gtk3-dark" else themeName;
        };
        colorScheme = "dark";

        # TODO might wanna try out papirus dark again
        # particularly for noctalia
        iconTheme.package = self.packages.${pkgs.stdenv.hostPlatform.system}.fkorpsvart-catppuccin-icons;
        iconTheme.name = iconThemeName;

        # causes issues otherwise
        # gtk4.theme.name = "";

        # KDE loves replacing this file
        gtk2.force = true;
      };

      qt = {
        enable = true;
        style.name = "kvantum";
        qt6ctSettings =
          if config.my.noctalia-themeing then
            {
              Appearance = {
                style = "kvantum";
                custom_palette = true;
                standard_dialogs = "xdgdesktopportal";
                color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf";
              };
            }
          else
            {
              Appearance = {
                style = "kvantum";
                custom_palette = true;
                standard_dialogs = "xdgdesktopportal";
              };
            };
      };
    };
}
