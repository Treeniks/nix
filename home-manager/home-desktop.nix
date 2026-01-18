{ pkgs, ... }:
{
  imports = [
    ./common
    ./common-graphical
  ];

  home.packages = with pkgs; [
    # NOTE: This app segfaults on wayland. To fix, start it once with x11:
    # XDG_SESSION_TYPE=x11 proton-mail
    # Subsequent starts will then work with wayland.
    # see https://github.com/NixOS/nixpkgs/issues/365156
    protonmail-desktop
    proton-pass

    olympus
  ];

  programs = {
    discord.enable = true;
  };
}
