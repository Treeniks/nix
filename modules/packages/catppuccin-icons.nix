{
  perSystem =
    { pkgs, ... }:
    {
      packages.fkorpsvart-catppuccin-icons = pkgs.stdenv.mkDerivation {
        pname = "fkorpsvart-catppuccin-icons";
        version = "0.1";

        src = pkgs.fetchFromGitHub {
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
    };
}
