{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ../common-graphical
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  nixpkgs.config.rocmSupport = true;

  hardware.xpadneo.enable = true;

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
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
      ];
    })
    steam-run
    wineWowPackages.waylandFull
  ];

  # NixOS's mesa drivers are quite monolithic and will in particular include the software "GPU" llvmpipe.
  # This "disables" llvmpipe in hopes of preventing Steam from shitting itself.
  # It probably does nothing though.
  #
  # `vulkaninfo --summary` however will now only show the real discrete GPU.
  environment.variables = {
    MESA_VK_DEVICE_SELECT = "1002:7550";
    MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";

    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
  };

  services.udev = {
    packages = [ pkgs.zsa-udev-rules ];
  };
}
