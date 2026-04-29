{
  flake.homeModules.zed =
    let
      userSettings = {
        base_keymap = "SublimeText";

        buffer_font_family = "Maple Mono";
        buffer_font_size = 18.0;
        icon_theme = "Catppuccin Mocha";
        ui_font_size = 16;

        disable_ai = true;
        enable_language_server = true;

        format_on_save = "off";
        vim_mode = true;
        relative_line_numbers = "enabled";

        minimap = {
          display_in = "all_editors";
          show = "always";
        };
        active_pane_modifiers = {
          inactive_opacity = 0.9;
        };

        languages = {
          LaTeX = {
            tab_size = 2;
            soft_wrap = "editor_width";
          };
          BibTeX = {
            tab_size = 2;
            format_on_save = "on";
          };
        };
      };

      userKeymaps = [
        {
          context = "(VimControl && !menu)";
          bindings = {
            k = [
              "vim::Up"
              {
                display_lines = true;
              }
            ];
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            j = [
              "vim::Down"
              {
                display_lines = true;
              }
            ];
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g k" = "vim::Up";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g j" = "vim::Down";
          };
        }
        {
          bindings = {
            ctrl-tab = "pane::ActivateNextItem";
          };
        }
        {
          bindings = {
            ctrl-shift-tab = "pane::ActivatePreviousItem";
          };
        }
        {
          context = "Editor";
          bindings = {
            alt-shift-f = "editor::Format";
          };
        }
      ];
    in
    {
      programs.zed-editor = {
        enable = true;
        inherit userSettings;
        inherit userKeymaps;
      };
    };
}
