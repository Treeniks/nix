{ inputs, self, ... }:
{
  flake.nixosModules.stackCommon = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin

      self.nixosModules.common
      self.nixosModules.neovim
      self.nixosModules.helix
      self.nixosModules.gpg
      self.nixosModules.theme
    ];
  };

  flake.homeModules.stackCommon = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin

      self.homeModules.common
      self.homeModules.helix
      self.homeModules.fish
      self.homeModules.yazi
      self.homeModules.theme
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
        vim.enable = true;
        firejail.enable = true;

        nix-index.enable = true;
      };

      environment.systemPackages = with pkgs; [
        emacs-pgtk

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
        zoxide = {
          enable = true;
          enableFishIntegration = true;
          options = [ "--cmd d" ];
        };
        lazygit.enable = true;

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
        cargo-edit
        mdbook
        tree-sitter
        deno
        mono
        nodejs
        (python3.withPackages (
          python-pkgs: with python-pkgs; [
            requests
            dbus
            pip
          ]
        ))
        julia
        nixfmt
        nixd
        taplo
        pre-commit
        gitu

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
