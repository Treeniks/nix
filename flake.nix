{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
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
      wrappers,
      catppuccin,
      apple-silicon,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    in
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

          chameleos = final.rustPlatform.buildRustPackage rec {
            pname = "chameleos";
            version = "0.1.2";
            src = final.fetchFromGitHub {
              owner = "Treeniks";
              repo = "chameleos";
              rev = "faca3aef0497bf14fc09ad154ab59862b5db4795";
              hash = "sha256-suOYeHBS9bIzyMvk6mviXXZVPviDhKdDvAyxSUNft3s=";
            };

            cargoLock.lockFile = "${src}/Cargo.lock";

            nativeBuildInputs = [
              final.makeWrapper
              final.pkg-config
              final.gitMinimal
            ];
            buildInputs = [ final.wayland ];

            postInstall = ''
              wrapProgram $out/bin/chameleos \
                --prefix LD_LIBRARY_PATH : "${
                  final.lib.makeLibraryPath [
                    final.wayland
                    final.libGL
                    final.vulkan-loader
                  ]
                }"
            '';
          };
        }
      );

      packages = forAllSystems (system: {
        neovim = wrappers.wrappers.neovim.wrap (
          {
            pkgs,
            ...
          }:
          {
            config = {
              pkgs = import nixpkgs { inherit system; };
              settings.config_directory = ./nvim;
              binName = "e";
              hosts.neovide.nvim-host.enable = true;

              specs.themes = {
                data = with pkgs.vimPlugins; [
                  catppuccin-nvim
                  rose-pine
                ];
                config = "vim.cmd.colorscheme('catppuccin-mocha')";
              };

              specs.treesitter.data = with pkgs.vimPlugins; [
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
              ];

              specs.telescope.data = with pkgs.vimPlugins; [ telescope-nvim ];

              specs.mini.data = with pkgs.vimPlugins; [
                mini-files
              ];

              specs.lsp.data = with pkgs.vimPlugins; [
                nvim-lspconfig
                blink-cmp
              ];
            };
          }
        );
      });

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
