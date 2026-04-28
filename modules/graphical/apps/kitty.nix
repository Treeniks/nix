# so this ones annoying
# I want to use the wrapper, but noctalia runs "kitty +runpy" to get the config to reload on theme change
# which for some reason just...doesn't work
# no idea why
{ self, ... }:
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
in
{
  flake.homeModules.kitty =
    { pkgs, ... }:
    {
      xdg.terminal-exec = {
        enable = true;
        package = pkgs.kitty;
      };

      programs.kitty = {
        enable = true;

        inherit font;
        inherit keybindings;
        inherit settings;
      };
    };

  # unused
  flake.homeModules.kittyWrapper =
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

      themeFile = "Catppuccin-Mocha";

      inherit font;
      inherit keybindings;
      inherit settings;
    };

  perSystem.wrappers.packages.noctalia-shell-kitty = true;
  flake.wrappers.noctalia-shell-kitty =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

      settings = {
        templates = {
          activeTemplates = [
            {
              id = "kitty";
              enabled = true;
            }
          ];
        };
      };
    };
}
