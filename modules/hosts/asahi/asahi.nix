{
  inputs,
  self,
  den,
  ...
}:
let
  hostname = "houjicha-nixos";
  system = "aarch64-linux";
in
{
  den.hosts.${system}.${hostname}.users.suteki = { };

  den.homes.${system}."suteki@${hostname}" = { };
  den.aspects.suteki.provides.${hostname}.includes = [ den.aspects.${hostname} ];

  den.aspects.${hostname} = {
    includes = [
      den.aspects.stackBase
      den.aspects.stackGui
    ];

    nixos = { pkgs, lib, ... }: {
      imports = [
        ./_hardware.nix
        inputs.apple-silicon.nixosModules.apple-silicon-support
      ];

      my = {
        niri.extraIncludes = [ "~/nix/modules/hosts/asahi/asahi.kdl" ];
        greetd.niri.extraIncludes = [ ./asahi.kdl ];
      };

      # asahi binary cache
      nix.settings = {
        extra-substituters = [ "https://nixos-apple-silicon.cachix.org" ];
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
      hardware.asahi.overlay = lib.composeExtensions inputs.apple-silicon.overlays.default self.overlays.asahi-fairydust;
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

      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };

      system.stateVersion = "26.05";
    };

    homeManager = {
      home = {
        username = "suteki";
        homeDirectory = "/home/suteki";
        stateVersion = "26.05";
      };
    };
  };

  flake.nixosConfigurations."${hostname}-cross" = self.nixosConfigurations.${hostname}.extendModules {
    modules = [
      {
        # cross compilation from x86-64 desktop
        # nix build --print-out-paths .#nixosConfigurations.houjicha-nixos-cross.config.boot.kernelPackages.kernel
        hardware.asahi.pkgsSystem = "x86_64-linux";
      }
    ];
  };
}
