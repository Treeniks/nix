{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    dotfiles = {
      url = "github:Treeniks/dotfiles";
      flake = false;
    };

    sublime-vinimum = {
      url = "github:Treeniks/Vinimum";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, catppuccin, dotfiles, sublime-vinimum, ... }: {
    nixosConfigurations.matcha-nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos/hosts/desktop/configuration.nix
        catppuccin.nixosModules.catppuccin
      ];
    };

    homeConfigurations.suteki = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit sublime-vinimum;
        inherit dotfiles;
      };
      modules = [
        ./home-manager/home.nix
        catppuccin.homeModules.catppuccin
      ];
    };
  };
}
