{
  pkgs,
  lib,
  noctalia,
  ...
}:
{
  imports = [
    noctalia.homeModules.default

    ./noctalia.nix
    # ./waybar
    ./gtk.nix
    ./kitty.nix
    # ./mpv.nix
    ./sublime.nix
    ./zed.nix
  ];

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
    fuzzel.enable = true;
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

    gammastep

    chameleos

    appimage-run
    sdl-jstest # testing joysticks with sdl
  ];

  services = {
    awww.enable = true;
    dunst.enable = true;
    hyprpolkitagent.enable = true;
    # no gammastep, see below
  };

  # gammastep
  # the default home-manager module doesn't allow just setting a constant temperature
  # and the time-awareness causes insane microstutters
  # https://github.com/nix-community/home-manager/blob/master/modules/services/redshift-gammastep/lib/options.nix
  systemd.user.services.gammastep = {
    Unit = {
      Description = "Gammastep without useless time bullshit";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.gammastep} -P -O 4500";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  catppuccin = {
    # unsure why but this looks giga scuffed
    wleave.enable = false;
    gtk.icon.enable = false;
    mangohud.enable = false;
    cursors.enable = true;
  };

  # I'm not fully convinced by this one yet
  qt = {
    enable = true;
    style.name = "kvantum";
  };
}
