{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/3cfb9b1a-1c63-4c3d-99c6-e259b2dde390";

  fileSystems."/home" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=@nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3C5F-1015";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # doesn't work for some reason, don't know why
  # swapDevices = [ {
  #   device = "/swapfile";
  #   size = 16*1024;
  # } ];

  swapDevices = [ ];
  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
