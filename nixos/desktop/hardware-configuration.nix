{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5f8c5909-4b97-4977-8344-8186af286b61";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=@"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/5f8c5909-4b97-4977-8344-8186af286b61";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=@home"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/5f8c5909-4b97-4977-8344-8186af286b61";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@nix"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6C1A-825F";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # extra drives
  fileSystems."/mnt/d" = {
    device = "/dev/disk/by-uuid/6128BBCC5CA3C48E";
    fsType = "ntfs3";
  };
  fileSystems."/mnt/e" = {
    device = "/dev/disk/by-uuid/0AAA6E7BAA6E62E5";
    fsType = "ntfs3";
  };
  fileSystems."/mnt/f" = {
    device = "/dev/disk/by-uuid/C07EDEBF7EDEAD82";
    fsType = "ntfs3";
  };
  fileSystems."/mnt/q" = {
    device = "/dev/disk/by-uuid/77D4EF3025CC26ED";
    fsType = "ntfs3";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
