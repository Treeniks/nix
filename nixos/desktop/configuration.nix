{ pkgs, ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "matcha-nixos";

  programs = {
    # gamink
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      extraPackages = with pkgs; [
        gamescope
        gamemode
        SDL
        SDL2
        sdl3
        steam-run
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
    vulkan-tools

    wineWowPackages.waylandFull
  ];
}
