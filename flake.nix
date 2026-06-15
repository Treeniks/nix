{
  inputs = {
    # see https://github.com/NixOS/nixpkgs/issues/511900
    # and https://github.com/NixOS/nixpkgs/pull/516804
    # deno is super flaky on hydra right now and building it locally is rough
    # deno is a dependency of yt-dlp, and thus also of mpv
    # this is the last nixpkgs commit where both x86_64-linux and aarch64-linux built sucessfully on hydra
    #
    # check with:
    # # https://hydra.nixos.org/job/nixos/unstable/nixpkgs.deno.x86_64-linux
    # # https://hydra.nixos.org/job/nixos/unstable/nixpkgs.deno.aarch64-linux
    # nixpkgs.url = "github:NixOS/nixpkgs/657e2fa0760e27167cdacb1ec5d84782be312013";
    # # https://hydra.nixos.org/job/nixos/unstable/nixpkgs.lutris-free.x86_64-linux
    # nixpkgs-lutris.url = "github:NixOS/nixpkgs/b12141ef619e0a9c1c84dc8c684040326f27cdcc";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO should update to v5 at some point
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
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
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.wrappers.flakeModules.wrappers
        (inputs.import-tree ./modules)
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
