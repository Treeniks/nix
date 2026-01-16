{ pkgs, ... }:
{
  programs = {
    niri.enable = true;
    xwayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
    xwayland-satellite
    brightnessctl
  ];
}
