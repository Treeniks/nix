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
      self,
      nixpkgs,
      home-manager,
      wrappers,
      catppuccin,
      apple-silicon,
      sublime-vinimum,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      nixpkgsConfig = {
        nixpkgs = {
          overlays = [ self.overlays ];
          config.allowUnfree = true;
        };
      };

      mkHost =
        {
          hostname,
          system,
          extraModule ? { },
        }:
        {
          inherit hostname;

          nixos = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              mypkgs = self.packages.${system};
            };
            modules = [
              ./nixos/${hostname}
              catppuccin.nixosModules.catppuccin
              nixpkgsConfig
              extraModule
            ];
          };

          home = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = {
              inherit sublime-vinimum;
              mypkgs = self.packages.${system};
            };
            modules = [
              ./home-manager/${hostname}.nix
              catppuccin.homeModules.catppuccin
              nixpkgsConfig
            ];
          };
        };

      hosts = {
        desktop = mkHost {
          hostname = "matcha-nixos";
          system = "x86_64-linux";
        };
        asahi = mkHost {
          hostname = "houjicha-nixos";
          system = "aarch64-linux";
          extraModule = apple-silicon.nixosModules.apple-silicon-support;
        };
      };
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

              # for complete manual treesitter grammar install:
              # specs.treesitter-manual.data =
              #   let
              #     mkTS =
              #       lang: grammar:
              #       pkgs.runCommand "ts-${lang}-nvim" { } ''
              #         mkdir -p $out/parser
              #         mkdir -p $out/queries/${lang}
              #
              #         cp ${grammar}/parser $out/parser/${lang}.so
              #         cp -r ${grammar}/queries/* $out/queries/${lang}/
              #       '';
              #   in
              #   with pkgs.tree-sitter-grammars;
              #   [
              #     (mkTS "rust" tree-sitter-rust)
              #     (mkTS "nix" tree-sitter-nix)
              #   ];

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

              extraPackages = with pkgs; [
                rust-analyzer
                nixd
              ];
            };
          }
        );
      });

      nixosConfigurations = nixpkgs.lib.mapAttrs' (
        _: host: nixpkgs.lib.nameValuePair host.hostname host.nixos
      ) hosts;

      homeConfigurations = nixpkgs.lib.mapAttrs' (
        _: host: nixpkgs.lib.nameValuePair "suteki@${host.hostname}" host.home
      ) hosts;
    };
}
