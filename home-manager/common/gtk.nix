{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      fkorpsvart-catppuccin-icons = final.stdenv.mkDerivation {
        pname = "fkorpsvart-catppuccin-icons";
        version = "0.1";
        src = final.fetchFromGitHub {
          owner = "Fausto-Korpsvart";
          repo = "Catppuccin-GTK-Theme";
          rev = "f25d8cf688d8f224f0ce396689ffcf5767eb647e";
          hash = "sha256-W+NGyPnOEKoicJPwnftq26iP7jya1ZKq38lMjx/k9ss=";
        };

        installPhase = ''
          mkdir -p $out/share/icons/Catppuccin-Mocha/
          cp -r icons/Catppuccin-Mocha/* $out/share/icons/Catppuccin-Mocha/
        '';
      };
    })
  ];

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
