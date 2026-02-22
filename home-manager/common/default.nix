{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./fish.nix
  ];

  nixpkgs = {
    overlays = [ inputs.self.overlays ];
    config.allowUnfree = true;
  };

  home = {
    username = "suteki";
    homeDirectory = "/home/suteki";
    stateVersion = "26.05";
  };
  programs.home-manager.enable = true;

  xdg.userDirs.createDirectories = true;
  xdg.userDirs.enable = true;

  programs = {
    bat.enable = true;
    starship.enable = true;
    eza.enable = true;
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd d" ];
    };
  };

  home.packages = with pkgs; [
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
    tree-sitter
    deno
    mono
    nodejs-slim
    (python3.withPackages (python-pkgs: with python-pkgs; [ requests dbus ]))
    nixfmt
    nixd
    taplo

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

    texliveFull
    # not just for graphical as it's used by tex's svg package
    inkscape

    typst
  ];

  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "mocha";
  };
}
