{ inputs, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./gtk.nix
    ./kitty.nix
    # ./mpv.nix
    ./waybar
    ./sublime.nix
    ./zed.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays
    ];
    config.allowUnfree = true;
  };

  home = {
    username = "suteki";
    homeDirectory = "/home/suteki";
    stateVersion = "26.05";
  };
  programs.home-manager.enable = true;

  xdg.userDirs.createDirectories = true;
  xdg.userDirs.enable = true;
  xdg.terminal-exec = {
    enable = true;
    package = pkgs.kitty;
  };

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

  dconf.settings = {
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "kitty";
    };
  };

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

    obsidian.enable = true;
  };

  services = {
    swww.enable = true;
    gammastep = {
      enable = true;
      temperature.day = 4500;
      temperature.night = 4500;
      latitude = 51.0;
      longitude = 9.0;
    };
    dunst.enable = true;
    hyprpolkitagent.enable = true;
  };

  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "mocha";

    # unsure why but this looks giga scuffed
    wleave.enable = false;

    gtk.icon.enable = false;
  };

  # I'm not fully convinced by this one yet
  qt = {
    enable = true;
    style.name = "kvantum";
  };
}
