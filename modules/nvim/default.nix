{ self, ... }:
{
  # this is the base that hot-reload and standalone derive from
  # but is itself useless, hence why we disable its export into self.packages
  perSystem.wrappers.packages.neovim-base = true;
  flake.wrappers.neovim-base =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.neovim ];

      hosts.neovide.nvim-host.enable = true;

      specs.general.data = with pkgs.vimPlugins; [
        nvim-surround
      ];

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

      specs.mini.data = with pkgs.vimPlugins; [ mini-nvim ];

      specs.lsp.data = with pkgs.vimPlugins; [
        nvim-lspconfig
        blink-cmp
        lazydev-nvim
      ];

      extraPackages = with pkgs; [
        rust-analyzer
        nixd
        lua-language-server
      ];
    };

  flake.wrappers.neovim-standalone = {
    imports = [ self.wrapperModules.neovim-base ];

    settings.config_directory = ./.;
    binName = "e";
  };

  flake.wrappers.neovim-hot-reload = {
    imports = [ self.wrapperModules.neovim-base ];

    settings.config_directory = "/home/suteki/nix/modules/nvim/";
    binName = "e";
  };
}
