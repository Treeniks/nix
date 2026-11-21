{ inputs, ... }:
{
  treeniks.theme = {
    nixos = {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];

      catppuccin = {
        autoEnable = false;
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };
    };

    homeManager = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        autoEnable = false;
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };
    };
  };

  treeniks.theme.cursors = {
    # NOTE: Cursor theme is also set inside niri config
    # and often deviates from the global catppuccin settings above.
    # Makes cursors switch theme occassionally but I don't care enough to fix it.

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        catppuccin-cursors.mochaLavender
        catppuccin-cursors.mochaMaroon
      ];
    };

    homeManager = {
      home.pointerCursor.enable = true;
      catppuccin.cursors.enable = true;
    };
  };

  treeniks.theme.gtkqt = {
    homeManager = { pkgs, ... }: {
      # ===== GTK =====
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
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
