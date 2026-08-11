{ inputs, ... }:
{
  den.aspects.common = {
    nixos = { pkgs, ... }: {
      imports = [
        # use determinate nix
        # https://docs.determinate.systems/guides/advanced-installation/#nixos
        inputs.determinate.nixosModules.default
      ];
      nixpkgs.config.allowUnfree = true;

      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";
      services.xserver.xkb.layout = "us";

      users.users.suteki = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
        ];
      };
      users.defaultUserShell = pkgs.fish;

      documentation = {
        # enables the bottom three
        dev.enable = true;

        # these are enabled by default
        man.enable = true;
        info.enable = true;
        doc.enable = true;
      };
    };

    homeManager = {
      programs.home-manager.enable = true;
      nixpkgs.config.allowUnfree = true;

      xdg.userDirs.createDirectories = true;
      xdg.userDirs.enable = true;
    };
  };

  den.aspects.commonGui = {
    nixos = {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      services.printing.enable = true;
      services.libinput.enable = true;

      programs.dconf.enable = true;

      services.flatpak.enable = true;

      security.polkit.enable = true;

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      programs.xwayland.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.desktopManager.cosmic.enable = true;
    };

    homeManager = {
      # make brave use basic password store to avoid issues with switching
      # between different desktop environments
      xdg.desktopEntries."brave-browser" = {
        name = "Brave";
        exec = "brave --password-store=basic %U";
        terminal = false;
        icon = "brave-browser";
        categories = [
          "Network"
          "WebBrowser"
        ];
      };
    };
  };
}
