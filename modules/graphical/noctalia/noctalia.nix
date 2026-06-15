{ inputs, ... }:
let
  settings = {
    general = {
      clockFormat = "HH:mm:ss";

      enableBlurBehind = true;
      enableShadows = true;
      shadowDirection = "center";
    };

    bar = {
      density = "default";
      position = "top";
      backgroundOpacity = 0.5;
      displayMode = "always_visible";
      hideOnOverview = false;

      mouseWheelAction = "workspace";
      mouseWheelWrap = true;

      outerCorners = true;

      middleClickAction = "settings";
      middleClickFollowMouse = false;

      rightClickAction = "none";

      widgets = {
        left = [
          { id = "Workspace"; }
          { id = "ActiveWindow"; }
        ];
        center = [
          {
            id = "Clock";
            tooltipFormat = "";
            formatHorizontal = "dddd yyyy-MM-dd | HH:mm:ss";

            useCustomFont = false;
          }
        ];
        right = [
          { id = "SystemMonitor"; }
          { id = "MediaMini"; }
          { id = "Battery"; }
          { id = "Brightness"; }
          {
            id = "Network";
            displayMode = "alwaysShow";
          }
          {
            id = "Bluetooth";
            displayMode = "alwaysShow";
          }
          {
            id = "Volume";
            displayMode = "alwaysShow";
          }
          { id = "Tray"; }
          { id = "NotificationHistory"; }
          {
            id = "ControlCenter";
            useDistroLogo = true;
          }
        ];
      };
    };

    wallpaper = {
      enabled = true;

      overviewEnabled = false;

      setWallpaperOnAllMonitors = true;
      skipStartupTransition = false;
      transitionType = [
        "stripes"
        "honeycomb"
      ];
    };

    ui = {
      boxBorderEnabled = false;
      panelBackgroundOpacity = 0.8;
      panelsAttachedToBar = true;
      fontDefault = "Roboto Medium";
      fontDefaultScale = 1.1;
      fontFixed = "Maple Mono";
      fontFixedScale = 1;
    };

    notifications = {
      enabled = true;
      density = "compact";
      backgroundOpacity = 0.8;
    };

    idle = {
      enabled = true;
      fadeDuration = 5;
      screenOffTimeout = 600;
      lockTimeout = 660;
      suspendTimeout = 0;
    };

    sessionMenu = {
      enableCountdown = false;

      largeButtonsStyle = true;
      largeButtonsLayout = "single-row";

      position = "center";

      powerOptions = [
        {
          action = "lock";
          enabled = true;
          keybind = "1";
        }
        {
          action = "logout";
          enabled = true;
          keybind = "2";
        }
        {
          action = "shutdown";
          enabled = true;
          keybind = "3";
        }
        {
          action = "reboot";
          enabled = true;
          keybind = "4";
        }
        {
          action = "rebootToUefi";
          enabled = true;
          keybind = "5";
        }

        {
          action = "suspend";
          enabled = false;
        }
        {
          action = "hibernate";
          enabled = false;
        }
        {
          action = "userspaceReboot";
          enabled = false;
        }
      ];
    };

    nightLight = {
      enabled = true;
      autoSchedule = false;
      forced = true;
      nightTemp = "4500";
    };

    colorSchemes = {
      darkMode = true;
      schedulingMode = "off";
      syncGsettings = true;
      useWallpaperColors = true;
      generationMethod = "content";
    };

    location = {
      autoLocate = false;
      use12hourFormat = false;
      weatherEnabled = false;
      firstDayOfWeek = 1; # Monday
    };

    dock.enabled = false;
    desktopWidgets.enabled = false;
  };
in
{
  flake.nixosModules.noctalia = {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.tuned.enable = true;
    services.upower.enable = true;
  };

  flake.homeModules.noctalia =
    { config, lib, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];
      programs.noctalia-shell = {
        enable = true;

        settings = lib.mkMerge [
          settings
          (lib.mkIf config.my.noctalia-themeing {
            # These are theme files exported by noctalia to keep themes of different applications in sync with noctalias colors.
            # This is a bit scuffed when it comes to nix. Basically, we know where noctalia writes these, and then import them in the respective configs.
            templates = {
              enableUserTheming = true;

              activeTemplates = [
                # these all have additional configuration related to
                # noctalia themeing
                {
                  id = "niri";
                  enabled = true;
                }
                {
                  id = "fuzzel";
                  enabled = true;
                }
                {
                  id = "kitty";
                  enabled = true;
                }
                {
                  id = "yazi";
                  enabled = true;
                }
                {
                  id = "neovim";
                  enabled = true;
                }
                # needs to be enabled manually in the settings
                # ...I think
                {
                  id = "zed";
                  enabled = true;
                }

                # I hate these
                {
                  id = "gtk";
                  enabled = true;
                }
                {
                  id = "qt";
                  enabled = true;
                }
                {
                  id = "kcolorscheme";
                  enabled = true;
                }

                # the rest are not managed by home manager or wrappers
                # so this will just work
                {
                  id = "btop";
                  enabled = true;
                }
                {
                  id = "hyprtoolkit";
                  enabled = true;
                }
                # TODO waiting for https://github.com/NixOS/nixpkgs/pull/487045
                # {
                #   id = "steam";
                #   enabled = true;
                # }
              ];
            };
          })
        ];

        # we enable/disable user templates based on noctalia-theme settings
        # so we can define this template always and just have it not activated
        # when noctalia themeing is disabled
        user-templates = {
          config = { };
          templates = {
            neovim = {
              input_path = "${./matugen-template.lua}";
              output_path = "~/nix/modules/nvim/lua/plugins/catppuccin-matugen.lua";
              post_hook = "pkill -SIGUSR1 nvim";
            };
          };
        };
      };

      home.activation.removeNvimThemeIfDisabled = lib.mkIf (!config.my.noctalia-themeing) (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          rm -f "$HOME/nix/modules/nvim/lua/plugins/catppuccin-matugen.lua"
        ''
      );
    };

  # unused in this config
  # due to noctalias rather ugly way of dealing with config files
  # wrappers didn't play nice
  flake.wrappers.noctalia-shell =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];
      inherit settings;
    };
}
