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

      self.nixosModules.noctalia
    ];
  };

  flake.homeModules.stackGraphical = {
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

      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          let
            editor_sublime = "sublime_text.desktop";
            editor_neovide = "neovide.desktop";
            editor_helix = "Helix.desktop";
            editor = editor_neovide;

            browser = "brave-browser.desktop";
            image = "org.gnome.eog.desktop";
            video = "mpv.desktop";
            audio = "mpv.desktop";
            pdf = "org.gnome.Evince.desktop";
          in
          {
            # see https://mimetype.io/all-types
            "text/javascript" = editor;
            "text/markdown" = editor;
            "text/plain" = editor;
            "text/x-asm" = editor;
            "text/x-c" = editor;
            "text/x-fortran" = editor;
            "text/x-java-source" = editor;
            "text/x-pascal" = editor;
            "text/x-python" = editor;

            "text/html" = browser;

            "image/bmp" = image;
            "image/gif" = image;
            "image/jpeg" = image;
            "image/png" = image;
            "image/tiff" = image;
            "image/webp" = image;

            "video/mp2t" = video; # .ts
            "video/mp4" = video;
            "video/mpeg" = video;
            "video/ogg" = video;
            "video/quicktime" = video;
            "video/webm" = video;
            "video/x-m4v" = video;
            "video/x-matroska" = video;

            "audio/aac" = audio;
            "audio/flac" = audio;
            "audio/mp4" = audio;
            "audio/mpeg" = audio;
            "audio/ogg" = audio;
            "audio/opus" = audio;
            "audio/wav" = audio;
            "audio/webm" = audio;
            "audio/x-matroska" = audio;
            "audio/x-ms-wma" = audio;

            "application/pdf" = pdf;
          };
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
