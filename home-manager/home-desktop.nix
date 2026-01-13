{ pkgs, ... }:
{
  imports = [
    ./common
  ];

  home.packages = with pkgs; [
    protonmail-desktop
    proton-pass
  ];

  programs = {
    discord.enable = true;
  };
}
