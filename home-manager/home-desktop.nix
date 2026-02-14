{ pkgs, ... }:
{
  imports = [
    ./common
    ./common-graphical
  ];

  nixpkgs.config.rocmSupport = true;

  home.packages = with pkgs; [
    # NOTE: This app segfaults on wayland. To fix, start it once with x11:
    # XDG_SESSION_TYPE=x11 proton-mail
    # Subsequent starts will then work with wayland.
    # see https://github.com/NixOS/nixpkgs/issues/365156
    protonmail-desktop
    proton-pass

    kdePackages.kdenlive
    teamspeak6-client
    uxplay

    # game stuff
    archipelago # has some issues, so probably prefer to use the manual download
    olympus
    dolphin-emu
    protontricks
    poptracker
    mangohud
    lumafly
  ];

  programs = {
    discord = {
      enable = true;
      settings = {
        "MINIMIZE_TO_TRAY" = false;
        "OPEN_ON_STARTUP" = false;
      };
    };
    obs-studio.enable = true;
  };
}
