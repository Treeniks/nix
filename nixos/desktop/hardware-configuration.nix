{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/698eca17-01e3-4ee1-aa1b-e18429c29a46";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/698eca17-01e3-4ee1-aa1b-e18429c29a46";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/698eca17-01e3-4ee1-aa1b-e18429c29a46";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=@nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9701-EA94";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
