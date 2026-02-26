{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5f8c5909-4b97-4977-8344-8186af286b61";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5f8c5909-4b97-4977-8344-8186af286b61";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/5f8c5909-4b97-4977-8344-8186af286b61";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=@nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6C1A-825F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
