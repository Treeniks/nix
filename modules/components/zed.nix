let
  userSettings = {
    base_keymap = "SublimeText";

    buffer_font_family = "Maple Mono";
    buffer_font_size = 18.0;
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
  # TODO replace with a wrapper and have the settings be editable using zed's GUI
  # similar to how niri and neovim are set up
  flake.homeModules.zed = {
    catppuccin.zed.enable = true;
    programs.zed-editor = {
      enable = true;
      inherit userKeymaps;
      inherit userSettings;
    };
  };
}
