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

  outputs =
    {
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "matcha-nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/desktop/configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };
      };

      homeConfigurations = {
        "suteki@matcha-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/home.nix
            catppuccin.homeModules.catppuccin
          ];
        };
      };
    };
}
