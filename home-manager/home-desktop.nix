{ pkgs, ... }:
{
  imports = [
    ./common
    ./common-graphical
  ];

  home.packages = with pkgs; [
    protonmail-desktop
    proton-pass

    olympus
  ];

  programs = {
    discord.enable = true;
  };
}
