{ self, ... }:
{
  flake.nixosModules.gtkqtTheme = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      (pkgs.magnetic-catppuccin-gtk.override { accent = [ "lavender" ]; })
      catppuccin-cursors.mochaLavender
      catppuccin-cursors.mochaMaroon
      self.packages.${pkgs.stdenv.hostPlatform.system}.fkorpsvart-catppuccin-icons
    ];
  };

  flake.homeModules.gtkqtTheme = { pkgs, ... }: {
    # ===== GTK =====
    gtk = {
      enable = true;
      theme.name = "Catppuccin-GTK-Lavender-Dark";
      iconTheme.name = "Catppuccin-Mocha";
      colorScheme = "dark";

      gtk2.force = true;
    };

    # ===== QT =====
    home.packages = [ pkgs.kdePackages.qt6ct ];

    catppuccin = {
      kvantum.enable = true;
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      qt6ctSettings = {
        Appearance = {
          style = "kvantum";
          custom_palette = true;
          standard_dialogs = "xdgdesktopportal";
        };
      };
    };
  };
}
