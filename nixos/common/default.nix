{ pkgs, mypkgs, ... }:
{
  imports = [ ];

  nix.settings.experimental-features = "nix-command flakes";

  # nix-collect-garbage -d
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 7d";
  # };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";

  users.users.suteki = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  users.defaultUserShell = pkgs.fish;

  programs = {
    git.enable = true;
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    vim.enable = true;
    firejail.enable = true;

    nix-index.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mypkgs.neovim
    helix

    killall
    wget
    qemu
    quickemu

    man-pages
    man-pages-posix
  ];

  documentation.dev.enable = true;

  system.stateVersion = "26.05";
}
