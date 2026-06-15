{ self, ... }:
{
  flake.nixosModules.stackGraphical =
    { lib, ... }:
    {
      imports = [
        self.nixosModules.graphicalBase
        self.nixosModules.graphicalDesktop
        self.nixosModules.graphicalFonts
        self.nixosModules.graphicalTheme

        self.nixosModules.niri
        self.nixosModules.greetdNiriReGreet

        self.nixosModules.noctalia
      ];

      options = {
        my.noctalia-themeing = lib.mkOption {
          type = lib.types.bool;
        };
      };
    };

  flake.homeModules.stackGraphical =
    { lib, ... }:
    {
      imports = [
        self.homeModules.graphicalBase
        self.homeModules.graphicalTheme

        self.homeModules.noctalia

        self.homeModules.kitty
        self.homeModules.fuzzel
        self.homeModules.nemo

        self.homeModules.mpv
        self.homeModules.sublime
        self.homeModules.zed
      ];

      options = {
        my = {
          noctalia-themeing = lib.mkOption {
            type = lib.types.bool;
          };
        };
      };
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

  flake.nixosModules.graphicalDesktop = {
    programs.xwayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.desktopManager.cosmic.enable = true;
  };

  flake.homeModules.graphicalBase =
    { pkgs, ... }:
    {
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

      programs = {
        neovide.enable = true;
        obsidian.enable = true;
      };

      home.packages = with pkgs; [
        vulkan-tools

        nwg-look
        pavucontrol
        coppwr
        wl-clipboard-rs
        xwininfo
        hyprpicker
        nautilus

        brave
        eog
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
