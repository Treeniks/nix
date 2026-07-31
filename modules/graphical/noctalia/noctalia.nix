{ inputs, ... }:
let
  settings = {
    theme = {
      # not used because I source from wallpaper,
      # but in case I don't want it off the wallpaper, it's nice when it's set
      builtin = "Rosé Pine";
      source = "wallpaper";
      wallpaper_scheme = "m3-tonal-spot";
    };

    shell = {
      corner_radius_scale = 2.0;
      font_family = "Roboto Medium";
      animation.speed = 2.0;

      offline_mode = true;
      polkit_agent = true;

      panel = {
        control_center_position = "center";
        open_near_click_control_center = true;
        open_near_click_session = true;
        open_near_click_wallpaper = true;
        session_placement = "floating";
        session_position = "center";

        # not used as wallpaper settings are attached
        # but I may want to change that
        wallpaper_position = "center";
      };

      session.actions = [
        # variant colors the button
        # and it's commented out because it's a bit bugged with the shortcut overlay
        {
          enabled = true;
          action = "lock";
          shortcut = "1";
          # variant = "default";
        }
        {
          enabled = true;
          action = "logout";
          shortcut = "2";
          # variant = "primary";
        }
        {
          enabled = true;
          action = "shutdown";
          shortcut = "3";
          # variant = "destructive";
        }
        {
          enabled = true;
          action = "reboot";
          shortcut = "4";
          # variant = "destructive";
        }
      ];
    };

    control_center = {
      sidebar = "full";
      sidebar_section = "full";
      width = 900;

      shortcuts = [
        { type = "wifi"; }
        { type = "bluetooth"; }
        { type = "nightlight"; }
        { type = "notification"; }
        { type = "power_profile"; }
        { type = "wallpaper"; }
      ];
    };

    nightlight = {
      enabled = true;
      force = true;
    };

    weather.enabled = false;

    lockscreen = {
      blur_intensity = 0.9;
      blurred_desktop = true;
    };

    bar.default = {
      background_opacity = 0.80;
      font_family = "Roboto";
      font_weight = 700;

      margin_ends = 0;
      radius_top_left = 0;
      radius_top_right = 0;
      widget_spacing = 12;

      start = [
        "workspaces"
        "wallpaper"
        "active_window"
      ];
      center = [
        "clock"
        "tray"
      ];
      end = [
        "media"
        "sysmon"
        "clipboard"
        "battery"
        "brightness"
        "network"
        "bluetooth"
        "volume"
        "notifications"
        "control-center"
        "session"
      ];

      dead_zone.actions.middle = "settings-open";
    };

    widget.clock = {
      anchor = true;
      format = "{:%A %F | %H:%M:%S}";
    };
    widget.volume = {
      actions.middle = "exec pavucontrol";
    };
  };
in
{
  flake.nixosModules.noctalia = { lib, ... }: {
    imports = [ inputs.noctalia.nixosModules.default ];

    options = {
      my.noctalia-themeing = lib.mkOption {
        type = lib.types.bool;
      };
    };

    config = {
      # cachix binary cache
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };
    };
  };

  flake.homeModules.noctalia =
    { config, lib, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      options = {
        my.noctalia-themeing = lib.mkOption {
          type = lib.types.bool;
        };
      };

      config = {
        programs.noctalia = {
          enable = true;
          inherit settings;
        };
      };
    };

  # TODO
  # unused in this config
  # due to noctalias rather ugly way of dealing with config files
  # wrappers didn't play nice
  # flake.wrappers.noctalia-shell =
  #   { wlib, ... }:
  #   {
  #     imports = [ wlib.wrapperModules.noctalia-shell ];
  #     inherit settings;
  #   };
}
