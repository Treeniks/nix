{ self, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        package = (
          self.wrappers.neovim.wrap {
            inherit pkgs;
            settings.config_directory = "/home/suteki/nix/modules/nvim/";
          }
        );
      };
    };

  flake.wrappers.neovim =
    {
      pkgs,
      lib,
      wlib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.neovim ];

      settings.config_directory = lib.mkDefault ./.;

      hosts.neovide.nvim-host.enable = true;

      specs.general.data = with pkgs.vimPlugins; [
        nvim-surround
        yazi-nvim
        lazygit-nvim
        direnv-vim
      ];

      specs.themes = {
        data = with pkgs.vimPlugins; [
          catppuccin-nvim
          rose-pine
        ];
        config = "vim.cmd.colorscheme('catppuccin-mocha')";
      };

      # for complete manual treesitter grammar install:
      specs.treesitter-manual.data =
        let
          mkTS =
            lang: grammar:
            pkgs.runCommand "ts-${lang}-nvim" { } ''
              mkdir -p $out/parser
              mkdir -p $out/queries/${lang}

              cp ${grammar}/parser $out/parser/${lang}.so
              cp -r ${grammar}/queries/* $out/queries/${lang}/
            '';
        in
        [
          (mkTS "styx" (
            pkgs.tree-sitter.buildGrammar {
              language = "styx";
              version = "";
              src = pkgs.fetchFromGitHub {
                owner = "facet-rs";
                repo = "facet";
                rev = "893e3733fde7bc27f5c3323120ffe4d3fbd79295";
                hash = "sha256-jHJclM9wRIOXa1D+5jzRjBY9I82NLdTBLobqh7HhLI0=";
              };
              location = "tree-sitter-styx";
            }
          ))
        ];

      specs.treesitter.data = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
      ];

      specs.telescope.data = with pkgs.vimPlugins; [ telescope-nvim ];

      specs.mini.data = with pkgs.vimPlugins; [ mini-nvim ];

      specs.lsp.data = with pkgs.vimPlugins; [
        nvim-lspconfig
        blink-cmp
        lazydev-nvim
      ];

      runtimePkgs = with pkgs; [
        rust-analyzer
        nixd
        lua-language-server
      ];
    };
}
