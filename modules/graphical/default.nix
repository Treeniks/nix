{ self, ... }:
{
  flake.nixosModules.stackGraphical = {
    imports = [
      self.nixosModules.graphicalBase
      self.nixosModules.graphicalDesktop
      self.nixosModules.graphicalFonts
      self.nixosModules.graphicalTheme

      self.nixosModules.niri
      self.nixosModules.greetdNiriReGreet
    ];
  };

  flake.homeModules.stackGraphical = {
    imports = [
      self.homeModules.graphicalBase
      self.homeModules.graphicalTheme

      self.homeModules.kitty
      # TODO
      # self.homeModules.mpv
      self.homeModules.sublime
      self.homeModules.zed
    ];
  };

  flake.nixosModules.graphicalBase =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      services.printing.enable = true;
      services.libinput.enable = true;

      # required for nemo etc. to list other drives
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      programs.dconf.enable = true;

      virtualisation.spiceUSBRedirection.enable = true;
      environment.systemPackages = with pkgs; [
        spice-gtk
      ];

      services.flatpak.enable = true;

      security.polkit = {
        enable = true;
      };

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

  flake.nixosModules.graphicalDesktop =
    { pkgs, ... }:
    {
      programs.xwayland.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.desktopManager.cosmic.enable = true;
      environment.systemPackages = [ pkgs.xwayland-satellite ];
    };

  flake.homeModules.graphicalBase =
    { pkgs, ... }:
    {
      xdg.terminal-exec = {
        enable = true;
        package = pkgs.kitty;
      };

      # make brave use basic password store to avoid issues with switching
      # between different desktop environments
      xdg.desktopEntries."brave-browser" = {
        name = "Brave";
        exec = "brave --password-store=basic %U";
        terminal = false;
        icon = "brave-browser";
        categories = [
          "Network"
          "WebBrowser"
        ];
      };

      # make nemo's "Open in Termianl" action open kitty
      dconf.settings = {
        "org/cinnamon/desktop/applications/terminal" = {
          exec = "kitty";
        };
      };

      programs = {
        wleave.enable = true;

        neovide.enable = true;
        obsidian.enable = true;

        # already enabled in common
        yazi = {
          keymap = {
            mgr.prepend_keymap = [
              {
                on = [
                  "g"
                  "b"
                ];
                run = "shell -- awww img \"$0\"";
                desc = "Make Background";
              }
            ];
          };
        };
      };

      home.packages = with pkgs; [
        vulkan-tools

        nwg-look
        pavucontrol
        coppwr
        nemo-with-extensions
        wl-clipboard-rs
        xwininfo
        hyprpicker
        nautilus

        brave
        eog
        mpv
        gnome-font-viewer
        evince
        proton-vpn
        # other proton stuff is system specific
        # as it's not available on arm currently
        qbittorrent
        signal-desktop
        thunderbird
        gimp
        firefox

        eduvpn-client

        gammastep

        chameleos

        appimage-run
        sdl-jstest # testing joysticks with sdl
      ];

      services.hyprpolkitagent.enable = true;
    };
}
