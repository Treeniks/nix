{ pkgs, ... }: {
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

    # causes issues otherwise
    gtk4.theme.name = "";
  };
}
