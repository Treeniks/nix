{ inputs, ... }:
let
  settings = {
    output = {
      # TV
      HDMI-A-1 = {
        mode = "3840x2160@119.880";
        position = [
          0
          150
        ];
        scale = 1.5;
        vrr = "fullscreen";

        bit_depth = 10;
        hdr = "auto";
      };

      # Main Monitor
      DP-1 = {
        mode = "2560x1440@300";
        position = [
          2560
          0
        ];
        scale = 1;
        vrr = "fullscreen";
      };

      # Side Monitor
      DP-2 = {
        mode = "1920x1080@143.980";
        position = [
          5120
          150
        ];
        scale = 1;
        vrr = "fullscreen";
      };
    };

    general.autostart = [ "noctalia" ];

    input.keyboard = {
      layout = "us";
      numlock_toggle = true;
      options = "fkeys:basic_13-24";
      repeat_delay = 200;
      variant = "altgr-intl";
    };

    input.mouse = {
      accel_profile = "flat";
      sensitivity = -0.45;
    };

    input.cursor = {
      size = 24;
      theme = "catppuccin-mocha-maroon-cursors";
    };

    keybinds =
      let
        norepeat = action: {
          inherit action;
          repeat = false;
        };
      in
      {
        "Mod+MouseMiddle" = "layout-scroll-drag";
        "Mod+WheelDown" = "workspace-next";
        "Mod+WheelUp" = "workspace-previous";
        "Mod+MouseBack" = "window-focus-left";
        "Mod+MouseForward" = "window-focus-right";

        "Mod+B" = "overview-toggle";

        "Mod+Space" = norepeat "spawn fuzzel";
        "Mod+Q" = norepeat "window-close";
        "Mod+Shift+Q" = norepeat "window-kill";

        "Mod+Backspace" = norepeat "spawn neovide";
        "Mod+T" = norepeat "spawn kitty";

        "Mod+D" = norepeat "spawn nemo";

        "Mod+E" = norepeat "spawn noctalia msg panel-toggle session";

        "Mod+F" = norepeat "window-toggle-maximize";
        "Mod+Shift+F" = norepeat "window-toggle-fullscreen";
        "Mod+Ctrl+F" = norepeat "window-toggle-maximize-to-edges";

        "Mod+H" = "window-focus-left";
        "Mod+J" = "window-focus-or-output-down";
        "Mod+K" = "window-focus-or-output-up";
        "Mod+L" = "window-focus-right";
        "Mod+Shift+H" = "window-move-or-output-left";
        "Mod+Shift+J" = "window-move-or-output-down";
        "Mod+Shift+K" = "window-move-or-output-up";
        "Mod+Shift+L" = "window-move-or-output-right";

        "Mod+U" = "workspace-next";
        "Mod+I" = "workspace-previous";
        "Mod+Shift+U" = "column-move-to-workspace-next";
        "Mod+Shift+I" = "column-move-to-workspace-previous";
        "Mod+Ctrl+U" = "workspace-move-down";
        "Mod+Ctrl+I" = "workspace-move-up";

        "Mod+Y" = "output-focus-left";
        "Mod+O" = "output-focus-right";
        "Mod+Shift+Y" = "column-move-to-output-left";
        "Mod+Shift+O" = "column-move-to-output-right";
        "Mod+Ctrl+Y" = "workspace-move-to-output-left";
        "Mod+Ctrl+O" = "workspace-move-to-output-right";

        "Mod+V" = "window-toggle-floating";
        "Mod+Shift+V" = "window-focus-switch-floating";

        "Mod+S" = norepeat "spawn noctalia msg screenshot-region";

        "Mod+Shift+E" = norepeat "session-quit";
        "Mod+Shift+Semicolon" = norepeat "spawn noctalia msg session lock";
        "Mod+Shift+P" = norepeat "dpms-off";
      };

    layout = {
      gap = 4;
      mode = "scrolling";
      scrolling = {
        center_focused = "never";
        default_extent_fraction = 0.5;
      };
    };

    workspaces = {
      empty_above = true;
    };

    overview.workspace_wallpaper = false;

    # pulse effect
    include.optional.files = [
      "/run/current-system/sw/share/umbriel/effects/border/pulse/effect.toml"
    ];
    effects.border = "pulse";

    animation = {
      enabled = true;
      duration_ms = 150;
      curve = "easeout";
    };

    appearance = {
      prefer_no_csd = true;

      border_width = 2;
      outer_border_width = 0;
      corner_radius = 20;
      drag_opacity = 0.95;
      opaque_fullscreen = false;

      blur = {
        enabled = true;
        optimized = true;
      };

      shadow.enabled = false;
    };

    window_rule = [
      {
        match.is_alone = true;
        default_maximize = true;
      }

      {
        match.content_type = "game";
        vrr = "always";
      }

      {
        match.app_id = [
          "^neovide$"
          "^kitty$"
          "^dev.zed.Zed$"
        ];
        blur = true;
      }

      {
        match.app_id = [ "^proton-pass$" ];
        block_capture = true;
      }
    ];
  };
in
{
  den.aspects.umbriel = {
    nixos = {
      imports = [ inputs.umbriel.nixosModules.default ];
      programs.umbriel.enable = true;
    };

    homeManager = {
      imports = [ inputs.umbriel.homeModules.default ];

      programs.umbriel = {
        enable = true;
        inherit settings;
      };
    };
  };
}
