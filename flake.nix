{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }: {
    nixosConfigurations.matcha-nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos/hosts/desktop/configuration.nix
        catppuccin.nixosModules.catppuccin
      ];
    };

    homeConfigurations.suteki = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home-manager/home.nix
        catppuccin.homeModules.catppuccin
      ];
    };
  };
}
