{ pkgs, ... }:
{
  imports = [
    ./greetd
    ./pipewire.nix
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  # nix-collect-garbage -d
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # TODO
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.printing.enable = true;

  services.libinput.enable = true;

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

  nixpkgs.config.allowUnfree = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs = {
    git.enable = true;
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    vim.enable = true;

    niri.enable = true;
    xwayland.enable = true;

    nix-index.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libxkbcommon
        vulkan-loader
        libGL
        wayland
      ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      settings = {
        default-cache-ttl = 7200;
        no-allow-external-cache = "";
      };
    };

    dconf.enable = true;
  };

  services.flatpak.enable = true;

  security.polkit = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    home-manager

    llvm
    clang
    clang-tools
    lld
    lldb

    gtkgreet
    xwayland-satellite

    # dev
    gcc
    rustup
    tree-sitter
    deno
    nodejs-slim
    (python3.withPackages (python-pkgs: with python-pkgs; [ requests ]))
    nixfmt-rfc-style
    nixd

    # cli
    wget
    ripgrep
    ouch

    (pkgs.magnetic-catppuccin-gtk.override { accent = [ "purple" ]; })
    catppuccin-cursors.mochaLavender
  ];

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf

    nerd-fonts.jetbrains-mono
    jetbrains-mono
    julia-mono
    maple-mono.variable
  ];

  catppuccin = {
    accent = "lavender";
    flavor = "mocha";

    sddm.enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "26.05";
}
