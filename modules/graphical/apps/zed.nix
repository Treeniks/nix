{
  flake.homeModules.zed =
    { lib, ... }:
    let
      userSettings = {
        base_keymap = "SublimeText";

        buffer_font_family = "Maple Mono";
        buffer_font_size = 18.0;
        icon_theme = "Catppuccin Mocha";
        theme = lib.mkForce "Noctalia Dark";
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
        userSettings = userSettings;
        userKeymaps = userKeymaps;
      };

      # we keep it enabled, but force noctalia above
      catppuccin.zed.enable = true;
    };

  perSystem.wrappers.packages.noctalia-shell-zed = true;
  flake.wrappers.noctalia-shell-zed =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

      settings = {
        templates = {
          activeTemplates = [
            {
              id = "zed";
              enabled = true;
            }
          ];
        };
      };
    };
}
