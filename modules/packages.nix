{
  flake.nixosModules.commonPackages = { pkgs, ... }: {
    programs = {
      firejail.enable = true;
      nix-index.enable = true;
    };

    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];
  };

  flake.homeModules.commonPackages = { pkgs, ... }: {
    programs = {
      git.enable = true;

      bat.enable = true;
      eza.enable = true;

      starship.enable = true;
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = [ "--cmd d" ];
      };

      btop.enable = true;

      direnv = {
        enable = true;
        enableFishIntegration = true;
        nix-direnv.enable = true;
      };
    };

    home.packages = with pkgs; [
      # llvm
      llvm
      (lib.hiPrio clang) # take prio over gcc
      clang-tools
      lld
      lldb

      # dev (tools)
      taplo
      pre-commit
      gnumake
      just

      # dev (languages)
      gcc
      gdb
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

      # nix
      nixfmt
      nixd

      # rust
      rustup
      cargo-edit
      mdbook

      # cli
      killall
      wget
      ripgrep
      ouch
      ffmpeg
      net-tools
      usbutils

      # tui
      gitu

      # TeX/typst
      texliveFull
      inkscape # used by tex's svg package
      typst

      # misc
      proton-vpn-cli
    ];
  };

  flake.homeModules.commonPackagesGui = { pkgs, ... }: {
    programs = {
      neovide.enable = true;
      obsidian.enable = true;
    };

    home.packages = with pkgs; [
      emacs-pgtk

      # debug stuff
      vulkan-tools
      sdl-jstest # testing joysticks with sdl

      # wayland tools
      wl-clipboard-rs
      xwininfo
      hyprpicker

      # audio
      pavucontrol
      coppwr

      # browsers
      brave
      firefox
      thunderbird

      # gnome apps
      nautilus
      eog
      gnome-font-viewer
      evince
      gimp

      # proton
      proton-vpn
      # other proton stuff is system specific
      # as it's not available on arm currently

      # misc
      qbittorrent
      signal-desktop
      eduvpn-client
      appimage-run

      chameleos
    ];
  };
}
