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

      runtimePkgs = with pkgs; [
        rust-analyzer
        nixd
        lua-language-server
      ];
    };
}
