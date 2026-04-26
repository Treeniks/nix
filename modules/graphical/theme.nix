{ self, ... }:
let
  accentedCatppuccin =
    pkgs:
    (pkgs.magnetic-catppuccin-gtk.override {
      accent = [ "lavender" ];
    });

  gtkThemeName = "Catppuccin-GTK-Lavender-Dark";
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
      ];

      programs.regreet = {
        theme.name = gtkThemeName;
        cursorTheme.name = "catppuccin-mocha-maroon-cursors";
        iconTheme.name = iconThemeName;
      };
    };

  flake.homeModules.graphicalTheme =
    { pkgs, ... }:
    {
      catppuccin = {
        gtk.icon.enable = false;
        mangohud.enable = false;
        cursors.enable = true;
      };

      gtk = {
        enable = true;
        theme = {
          package = accentedCatppuccin pkgs;
          name = gtkThemeName;
        };
        colorScheme = "dark";

        iconTheme.name = iconThemeName;
        iconTheme.package = self.packages.${pkgs.stdenv.hostPlatform.system}.fkorpsvart-catppuccin-icons;

        # causes issues otherwise
        gtk4.theme.name = "";

        # KDE loves replacing this file
        gtk2.force = true;
      };

      # I'm not fully convinced by this one yet
      qt = {
        enable = true;
        style.name = "kvantum";
      };
    };
}
