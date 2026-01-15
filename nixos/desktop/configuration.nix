{ pkgs, ... }:
{
  imports = [
    ../common
    ../common-graphical
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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
    wineWowPackages.waylandFull
  ];
}
