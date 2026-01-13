{
  programs.kitty = {
    enable = true;
    font.name = "JetBrains Mono";
    font.size = 13;

    keybindings = {
      "cmd+t" = "new_tab_with_cwd";
      "cmd+enter" = "new_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";

      "cmd+w" = "close_window";
      "cmd+shift+w" = "close_tab";
    };

    extraConfig = ''
      cursor_blink_interval   0

      hide_window_decorations titlebar-only
      window_margin_width 4

      tab_bar_edge top
      tab_bar_style powerline
      tab_powerline_style slanted

      background_opacity  0.98
    '';
  };
}
