{ inputs, self, ... }:
{
  flake.nixosModules.stackCommon = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin

      self.nixosModules.common
      self.nixosModules.gpg
      self.nixosModules.theme
    ];
  };

  flake.homeModules.stackCommon = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin

      self.homeModules.common
      self.homeModules.theme
      self.homeModules.fish
    ];
  };

  flake.nixosModules.common =
    { pkgs, ... }:
    {
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs = {
        config.allowUnfree = true;
      };

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

      programs = {
        git.enable = true;
        fish.enable = true;
        neovim = {
          enable = true;
          defaultEditor = true;
        };
        vim.enable = true;
        firejail.enable = true;

        nix-index.enable = true;
      };

      environment.systemPackages = with pkgs; [
        helix

        killall
        wget
        qemu
        quickemu

        man-pages
        man-pages-posix
      ];

      documentation.dev.enable = true;
    };

  flake.homeModules.common =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;
      nixpkgs = {
        config.allowUnfree = true;
      };

      xdg.userDirs.createDirectories = true;
      xdg.userDirs.enable = true;

      programs = {
        bat.enable = true;
        starship.enable = true;
        eza.enable = true;
        yazi = {
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "yy";
        };
        zoxide = {
          enable = true;
          enableFishIntegration = true;
          options = [ "--cmd d" ];
        };

        direnv = {
          enable = true;
          enableFishIntegration = true;
          nix-direnv.enable = true;
        };
      };

      home.packages = with pkgs; [
        proton-vpn-cli

        # llvm
        llvm
        (lib.hiPrio clang) # take prio over gcc
        clang-tools
        lld
        lldb

        # dev
        gcc
        gdb
        rustup
        mdbook
        tree-sitter
        deno
        mono
        nodejs-slim
        (python3.withPackages (
          python-pkgs: with python-pkgs; [
            requests
            dbus
            pip
          ]
        ))
        nixfmt
        nixd
        taplo
        pre-commit

        # cli
        wget
        ripgrep
        ouch
        btop
        starship
        eza
        yazi
        zoxide
        just
        gnumake
        ffmpeg
        net-tools
        usbutils

        texliveFull
        # not just for graphical as it's used by tex's svg package
        inkscape

        typst
      ];
    };
}
