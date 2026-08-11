{
  den.aspects.gtkqtTheme = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.adw-gtk3 ];
    };

    homeManager = { pkgs, ... }: {
      # ===== GTK =====
      gtk = {
        enable = true;
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
  };
}
