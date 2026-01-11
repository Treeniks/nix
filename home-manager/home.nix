{ config, pkgs, ... }: {
  imports = [
    ./fish.nix
    ./gtk.nix
    ./kitty.nix
    # ./mpv.nix
    ./waybar/waybar.nix
    ./zed.nix
  ];

  home = {
    username = "suteki";
    homeDirectory = "/home/suteki";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;

  xdg.userDirs.createDirectories = true;
  xdg.userDirs.enable = true;
  xdg.terminal-exec = {
    enable = true;
    package = pkgs.kitty;
  };

  dconf.settings = {
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "kitty";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  home.packages = with pkgs; [
    # TODO
    mpv

    btop

    nwg-look
    pavucontrol

    nemo-with-extensions
    brightnessctl

    brave
    sublime4
    sublime-merge
    gnome-font-viewer
    protonmail-desktop
    proton-pass
    protonvpn-gui
    qbittorrent

    hyprpolkitagent
  ];

  home.pointerCursor.package = pkgs.catppuccin-cursors.mochaLavender;
  home.pointerCursor.name = "catppuccin-mocha-lavender-cursors";

  programs = {
    bat.enable = true;
    starship.enable = true;
    eza.enable = true;
    yazi.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd d" ];
    };

    fuzzel.enable = true;
    wleave.enable = true;

    neovide.enable = true;

    discord.enable = true;
  };

  services = {
    dunst.enable = true;
    gammastep = {
      enable = true;
      temperature.day = 4500;
      temperature.night = 4500;
      latitude = 51.0;
      longitude = 9.0;
    };
  };

  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "mocha";

    # unsure why but this looks giga scuffed
    wleave.enable = false;
  };

  qt = {
    enable = true;
    style.name = "kvantum";
  };
}
