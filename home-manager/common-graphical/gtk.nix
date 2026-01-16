{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = (
        pkgs.magnetic-catppuccin-gtk.override {
          accent = [ "purple" ];
        }
      );
      name = "Catppuccin-GTK-Purple-Dark";
    };
    colorScheme = "dark";

    iconTheme.name = "Catppuccin-Mocha";
    iconTheme.package = pkgs.fkorpsvart-catppuccin-icons;

    # causes issues otherwise
    gtk4.theme.name = "";
  };
}
