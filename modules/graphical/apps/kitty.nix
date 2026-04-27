{ self, ... }:
{
  # repalced by wrapper
  flake.homeModules.kittyHomeManager = {
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
  };

  flake.homeModules.kitty =
    { pkgs, ... }:
    let
      kitty = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty;
    in
    {
      xdg.terminal-exec = {
        enable = true;
        package = kitty;
      };

      home.packages = [
        kitty
      ];
    };

  flake.wrappers.kitty =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.kitty ];

      font.name = "JetBrains Mono";
      font.size = 13;

      themeFile = "Catppuccin-Mocha";

      keybindings = {
        "cmd+t" = "new_tab_with_cwd";
        "cmd+enter" = "new_window_with_cwd";
        "ctrl+shift+t" = "new_tab_with_cwd";
        "ctrl+shift+enter" = "new_window_with_cwd";

        "cmd+w" = "close_window";
        "cmd+shift+w" = "close_tab";
      };

      settings = {
        # noctalia shell theme
        include = "~/.config/kitty/themes/noctalia.conf";

        "cursor_blink_interval" = 0;

        "hide_window_decorations" = "titlebar-only";
        "window_margin_width" = 4;

        "tab_bar_edge" = "top";
        "tab_bar_style" = "powerline";
        "tab_powerline_style" = "slanted";

        "background_opacity" = 0.98;
      };
    };
}
