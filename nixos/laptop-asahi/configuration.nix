{ pkgs, ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2 iso_layout=0 swap_opt_cmd=1 swap_fn_leftctrl=1
  '';

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
