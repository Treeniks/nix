# so this ones annoying
# I want to use the wrapper, but things like "kitty +runpy" is broken with it
# no idea why
#
# noctalia uses that to reload config on theme change so that causes issues
let
  font = {
    name = "JetBrains Mono";
    size = 13;
  };

  keybindings = {
    "cmd+t" = "new_tab_with_cwd";
    "cmd+enter" = "new_window_with_cwd";
    "ctrl+shift+t" = "new_tab_with_cwd";
    "ctrl+shift+enter" = "new_window_with_cwd";

    "ctrl+shift+m" = "detach_window ask";

    "cmd+w" = "close_window";
    "cmd+shift+w" = "close_tab";
  };

  settings = {
    "cursor_blink_interval" = 0;

    "hide_window_decorations" = "titlebar-only";
    "window_margin_width" = 4;

    "tab_bar_edge" = "top";
    "tab_bar_style" = "powerline";
    "tab_powerline_style" = "slanted";

    "background_opacity" = 0.98;

    # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.scrollback_pager
    "scrollback_pager" = "nvim --cmd 'set eventignore=FileType' +'nnoremap q ZQ' +'call nvim_open_term(0, {})' +'set nomodified nolist' +'$' -";

    "cursor_trail" = 1;
    "cursor_trail_decay" = "0.1 0.2";
    "cursor_trail_start_threshold" = 1;
    "shell_integration" = "no-cursor";
  };
in
{
  flake.homeModules.kitty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      xdg.terminal-exec = {
        enable = true;
        package = pkgs.kitty;
      };

      programs.kitty = lib.mkMerge [
        {
          enable = true;

          inherit font;
          inherit keybindings;

          settings = lib.mkMerge [
            settings
            (lib.mkIf config.my.noctalia-themeing {
              include = "~/.config/kitty/themes/noctalia.conf";
            })
          ];
        }
        (lib.mkIf config.my.noctalia-themeing {
          themeFile = lib.mkForce null;
        })
      ];

    };

  flake.wrappers.kitty =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.kitty ];

      themeFile = "Catppuccin-Mocha";

      inherit font;
      inherit keybindings;
      inherit settings;
    };
}
