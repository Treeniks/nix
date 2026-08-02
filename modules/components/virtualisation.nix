{
  flake.nixosModules.virtualisation = { pkgs, ... }: {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      libvirtd = {
        enable = true;
        qemu.vhostUserPackages = [ pkgs.virtiofsd ];
        qemu.swtpm.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      qemu
      quickemu
    ];

    services.samba.enable = true;
  };

  flake.nixosModules.virtualisationGui = { pkgs, ... }: {
    virtualisation.spiceUSBRedirection.enable = true;
    environment.systemPackages = [ pkgs.spice-gtk ];

    programs.virt-manager.enable = true;
  };
}
