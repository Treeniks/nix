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
    lumafly

    filen-desktop
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

    mangohud = {
      enable = true;
      settings = {
        legacy_layout = false;

        font_size = 32;
        font_file = /home/suteki/.local/share/fonts/MapleMono-Bold.ttf;
        text_outline = true;
        text_outline_color = 000000;
        text_outline_thickness = 1;

        horizontal = true;
        background_alpha = 0;
        horizontal_stretch = 0;
        position = "top-left";
        hud_compact = true;
        round_corners = 16;

        fps = true;
        frame_timing = true;
        cpu_stats = true;
        gpu_stats = true;
        # resolution = true

        text_color = "ffffff";

        engine_color = "f38ba8";
        frametime_color = "fab387";

        cpu_color = "89b4fa";
        gpu_color = "a6e3a1";
        horizontal_separator_color = "29263c";
        background_color = "15141b";
      };
    };
  };
}
