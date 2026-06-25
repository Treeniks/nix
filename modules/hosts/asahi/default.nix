{
  inputs,
  self,
  lib,
  ...
}:
let
  hostname = "houjicha-nixos";
  system = "aarch64-linux";

  noctalia-themeing = true;
in
{
  flake.nixosConfigurations.${hostname} = lib.nixosSystem {
    inherit system;

    modules = [
      ./_hardware.nix
      inputs.apple-silicon.nixosModules.apple-silicon-support
      self.nixosModules.${hostname}

      self.nixosModules.stackCommon

      self.nixosModules.stackGraphical
      self.nixosModules.stackPipewireFull
    ];
  };

  flake.homeConfigurations."suteki@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};

    modules = [
      self.homeModules.${hostname}

      self.homeModules.stackCommon
      self.homeModules.stackGraphical
    ];
  };

  flake.nixosModules.${hostname} =
    { pkgs, ... }:
    {
      my = {
        inherit noctalia-themeing;
        niri.extraIncludes = [ "~/nix/modules/hosts/asahi/asahi.kdl" ];
        greetd.niri.extraIncludes = [ ./asahi.kdl ];
      };

      networking.hostName = hostname;

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

      environment.systemPackages = [ pkgs.displaylink ];
      services.xserver.videoDrivers = [
        "displaylink"
        "modesetting"
      ];
      systemd.services.dlm.wantedBy = [ "multi-user.target" ];

      system.stateVersion = "26.05";
    };

  flake.homeModules.${hostname} = {
    my = {
      inherit noctalia-themeing;
    };

    home = {
      username = "suteki";
      homeDirectory = "/home/suteki";
      stateVersion = "26.05";
    };
  };
}
