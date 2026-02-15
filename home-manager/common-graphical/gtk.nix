{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = (
        pkgs.magnetic-catppuccin-gtk.override {
          accent = [ "lavender" ];
        }
      );
      name = "Catppuccin-GTK-Lavender-Dark";
    };
    colorScheme = "dark";

    iconTheme.name = "Catppuccin-Mocha";
    iconTheme.package = pkgs.fkorpsvart-catppuccin-icons;

    # causes issues otherwise
    gtk4.theme.name = "";
  };
}
