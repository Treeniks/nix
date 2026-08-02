{
  inputs,
  self,
  lib,
  ...
}:
let
  hostname = "houjicha-nixos";
  system = "aarch64-linux";
in
{
  flake.nixosConfigurations.${hostname} = lib.nixosSystem {
    inherit system;

    modules = [
      ./_hardware.nix
      inputs.apple-silicon.nixosModules.apple-silicon-support
      {
        nixpkgs.overlays = [
          self.overlays.asahi-fairydust
        ];
      }
      self.nixosModules.${hostname}

      self.nixosModules.stackBase
      self.nixosModules.stackGui
    ];
  };

  flake.homeConfigurations."suteki@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};

    modules = [
      self.homeModules.${hostname}

      self.homeModules.stackBase
      self.homeModules.stackGui
    ];
  };

  flake.nixosModules.${hostname} = { pkgs, ... }: {
    my = {
      niri.extraIncludes = [ "~/nix/modules/hosts/asahi/asahi.kdl" ];
      greetd.niri.extraIncludes = [ ./asahi.kdl ];
    };

    # asahi binary cache
    nix.settings = {
      extra-substituters = [
        "https://nixos-apple-silicon.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      ];
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

    hardware.asahi.enable = true;
    # https://github.com/nix-community/nixos-apple-silicon/issues/299#issuecomment-2901508921
    hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
      name = "vendorfw";
      hashMode = "recursive";
      # nix hash path --algo sha256 /boot/vendorfw
      hash = "sha256-PrS7+CFNtfHhDGHyDwe57AOyarPigGO9bebyRQW9kOg=";
      message = ''
        nix-store --add-fixed sha256 --recursive /boot/vendorfw
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
    home = {
      username = "suteki";
      homeDirectory = "/home/suteki";
      stateVersion = "26.05";
    };
  };
}
