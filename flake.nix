{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    # filen-desktop no worky on latest nixpkgs, no idea why
    nixpkgs-weekly.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    den.url = "github:denful/den";
    import-tree.url = "github:denful/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers = {
      # TODO this is temporary until my PR is merged
      # so I can use a yazi wrapper
      url = "github:Treeniks/nix-wrapper-modules/yazi-initlua";
      # url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sublime-vinimum = {
      url = "github:Treeniks/Vinimum";
      flake = false;
    };

    chameleos = {
      url = "github:Treeniks/chameleos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.wrappers.flakeModules.wrappers
        inputs.den.flakeModule

        (inputs.import-tree ./modules)
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
}
