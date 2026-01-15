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
    vulkan-tools

    xwayland-satellite
    hyprpolkitagent

    gammastep
    dunst
    brightnessctl

    nwg-look
    pavucontrol
    nemo-with-extensions

    wl-clipboard-rs

    brave
    mpv
    gnome-font-viewer
    evince
    protonvpn-gui
    # other proton stuff is system specific
    # as it's not available on arm currently
    qbittorrent
  ];
}
