{ self, ... }:
{
  flake.nixosModules.noctalia-shell =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell
      ];
    };

  flake.wrappers.noctalia-shell =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

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
              { id = "Trav"; }
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
            }
            {
              action = "logout";
              enabled = true;
            }
            {
              action = "shutdown";
              enabled = true;
            }
            {
              action = "reboot";
              enabled = true;
            }
            {
              action = "rebootToUefi";
              enabled = true;
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
        };

        dock.enabled = false;
        desktopWidgets.enabled = false;
      };
    };
}
