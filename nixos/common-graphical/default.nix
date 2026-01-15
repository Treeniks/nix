{ pkgs, ... }:
{
  imports = [
    ./greetd
    ./packages.nix # also includes packages
    ./fonts.nix
    ./pipewire.nix
    ./theme.nix
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;

  services.libinput.enable = true;

  # required for nemo etc. to list other drives
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs = {
    # TODO this is a hack for something that should be solved with nix-direnv
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libxkbcommon
        libGL
        fontconfig

        vulkan-loader
        wayland
      ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      settings = {
        default-cache-ttl = 7200;
        no-allow-external-cache = "";
      };
    };

    dconf.enable = true;
  };

  services.flatpak.enable = true;

  security.polkit = {
    enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
