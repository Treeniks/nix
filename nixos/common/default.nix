{ inputs, pkgs, ... }:
{
  imports = [
    ./packages.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs = {
    overlays = [
      inputs.self.overlays
    ];
    config.allowUnfree = true;
  };

  # nix-collect-garbage -d
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

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

    nix-index.enable = true;
  };

  system.stateVersion = "26.05";
}
