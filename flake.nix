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
      apple-silicon,
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
