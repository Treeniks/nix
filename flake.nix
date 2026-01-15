{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sublime-vinimum = {
      url = "github:Treeniks/Vinimum";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      catppuccin,
      apple-silicon,
      ...
    }@inputs:
    {
      overlays = (
        final: prev: {
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
        }
      );

      nixosConfigurations = {
        "matcha-nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/desktop/configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };

        "houjicha-nixos" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/laptop-asahi/configuration.nix
            apple-silicon.nixosModules.apple-silicon-support
            catppuccin.nixosModules.catppuccin
          ];
        };
      };

      homeConfigurations = {
        "suteki@matcha-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/home-desktop.nix
            catppuccin.homeModules.catppuccin
          ];
        };

        "suteki@houjicha-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/home-laptop-asahi.nix
            catppuccin.homeModules.catppuccin
          ];
        };
      };
    };
}
