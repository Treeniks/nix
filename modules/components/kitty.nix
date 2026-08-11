{ self, ... }:
let
  font = {
    name = "Maple Mono";
    size = 13;
  };

  keybindings = {
    "cmd+t" = "new_tab_with_cwd";
    "cmd+enter" = "new_window_with_cwd";
    "ctrl+shift+t" = "new_tab_with_cwd";
    "ctrl+shift+enter" = "new_window_with_cwd";

    "ctrl+shift+m" = "detach_window ask";

    # alternatives to ctrl+shift+[ and ctrl+shift+]
    # as [ and ] is a bit more involved to press on my split keyboard
    "ctrl+shift+;" = "previous_window";
    "ctrl+shift+'" = "next_window";

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

    "enabled_layouts" = "grid,tall";

    # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.scrollback_pager
    # a few issues:
    # - it starts at the bottom of the output, so I have to press 'gg' first (fixable)
    # - it doens't integrate with my probably-running-in-another-tab neovim anyway
    # - it doesn't work with helix yet
    # so I might as well just stick with default (less) for now? idk
    # "scrollback_pager" =
    #   "nvim --cmd 'set eventignore=FileType' +'nnoremap q ZQ' +'call nvim_open_term(0, {})' +'set nomodified nolist' +'$' -";

    # 200MB of scrollback (probably overkill, but I'd rather have too much)
    "scrollback_pager_history_size" = 200;

    "cursor_trail" = 1;
    "cursor_trail_decay" = "0.1 0.2";
    "cursor_trail_start_threshold" = 1;
    "shell_integration" = "no-cursor";
  };
in
{
  den.aspects.kitty.homeManager = {
    imports = [ self.wrappers.kitty.install ];
    wrappers.kitty.enable = true;
  };

  flake.wrappers.kitty = { wlib, ... }: {
    imports = [ wlib.wrapperModules.kitty ];

    themeFile = "Catppuccin-Mocha";

    inherit font;
    inherit keybindings;
    inherit settings;
  };
}
