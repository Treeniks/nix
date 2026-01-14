{ pkgs, ... }:
{
  imports = [
    ./common
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
