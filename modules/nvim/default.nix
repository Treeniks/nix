{ self, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-hot-reload;
      };
    };

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
  };

  flake.wrappers.neovim-hot-reload = {
    imports = [ self.wrapperModules.neovim-base ];
    settings.config_directory = "/home/suteki/nix/modules/nvim/";
  };

  perSystem.wrappers.packages.noctalia-shell-neovim = true;
  flake.wrappers.noctalia-shell-neovim =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

      user-templates = {
        config = { };
        templates = {
          neovim = {
            input_path = "${./matugen-template.lua}";
            output_path = "~/nix/modules/nvim/lua/plugins/catppuccin-matugen.lua";
            post_hook = "pkill -SIGUSR1 nvim";
          };
        };
      };

      settings = {
        templates = {
          activeTemplates = [
            {
              id = "neovim";
              enabled = true;
            }
          ];
        };
      };
    };
}
