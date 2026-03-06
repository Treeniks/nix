{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ../common-graphical
    ./hardware-configuration.nix
  ];

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        AddressRandomization = "once";
      };
    };
  };
  networking.networkmanager.wifi.backend = "iwd";

  # https://github.com/nix-community/nixos-apple-silicon/issues/299#issuecomment-2901508921
  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-JDEd6dDVRK1SfVLGfX97KgFbVGN0S5wmgNREn2rLVA0=";
    message = ''
      nix-store --add-fixed sha256 --recursive /boot/asahi
    '';
  };

  networking.hostName = "houjicha-nixos";
}
