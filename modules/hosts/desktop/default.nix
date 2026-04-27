{
  inputs,
  self,
  lib,
  ...
}:
let
  hostname = "matcha-nixos";
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.${hostname} = lib.nixosSystem {
    inherit system;

    modules = [
      ./_hardware.nix
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
      niriPackage = self.packages.${system}.niri-desktop-hot-reload;
      animemode = true;
      greetd.niriPackage = self.packages.${system}.niri-desktop-greetd;

      networking.hostName = hostname;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      nixpkgs.config.rocmSupport = true;

      hardware.xpadneo.enable = true;

      # only for uplay
      # networking.firewall.enable = false;
      # services.avahi = {
      #   enable = true;
      #   nssmdns4 = true;
      #   publish = {
      #     enable = true;
      #     userServices = true;
      #     domain = true;
      #   };
      # };

      programs = {
        # gamink
        steam = {
          enable = true;
          dedicatedServer.openFirewall = true;
          extraPackages = with pkgs; [
            gamescope
            gamemode
            SDL
            SDL2
            sdl3
            steam-run
          ];
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
        gamescope.enable = true;
        gamemode.enable = true;
      };

      environment.systemPackages = with pkgs; [
        (heroic.override {
          extraPkgs = pkgs: [
            pkgs.gamescope
          ];
        })
        steam-run
        wineWow64Packages.full
      ];

      # NixOS's mesa drivers are quite monolithic and will in particular include the software "GPU" llvmpipe.
      # This "disables" llvmpipe in hopes of preventing Steam from shitting itself.
      # It probably does nothing though.
      #
      # `vulkaninfo --summary` however will now only show the real discrete GPU.
      environment.variables = {
        MESA_VK_DEVICE_SELECT = "1002:7550";
        MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";

        VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
      };

      services.udev = {
        packages = [ pkgs.zsa-udev-rules ];
        # WLMouse
        # I think this one also requires the specific product id, either way it didn't work for me
        # SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36a7", TAG+="uaccess"
        extraRules = ''
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36a7", MODE="0777"
        '';
      };

      system.stateVersion = "26.05";
    };

  flake.homeModules.${hostname} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # NOTE: This app segfaults on wayland. To fix, start it once with x11:
        # XDG_SESSION_TYPE=x11 proton-mail
        # Subsequent starts will then work with wayland.
        # see https://github.com/NixOS/nixpkgs/issues/365156
        protonmail-desktop
        proton-pass
        filen-desktop

        kdePackages.kdenlive
        teamspeak6-client
        uxplay

        # game stuff
        archipelago
        olympus
        r2modman
        dolphin-emu
        protontricks
        poptracker
        lumafly
        cemu
        eden
        prismlauncher
        uzdoom

        godot
      ];

      programs = {
        discord = {
          enable = true;
          settings = {
            "MINIMIZE_TO_TRAY" = false;
            "OPEN_ON_STARTUP" = false;
          };
        };
        obs-studio.enable = true;

        mangohud = {
          enable = true;
          settings = {
            legacy_layout = false;

            font_size = 32;
            # TODO test if this even works
            font_file = "${pkgs.maple-mono.variable}/share/fonts/truetype/MapleMono[wght].ttf";
            text_outline = true;
            text_outline_color = 000000;
            text_outline_thickness = 1;

            horizontal = true;
            background_alpha = 0;
            horizontal_stretch = 0;
            position = "top-left";
            hud_compact = true;
            round_corners = 16;

            fps = true;
            frame_timing = true;
            cpu_stats = true;
            gpu_stats = true;
            # resolution = true

            text_color = "ffffff";

            engine_color = "f38ba8";
            frametime_color = "fab387";

            cpu_color = "89b4fa";
            gpu_color = "a6e3a1";
            horizontal_separator_color = "29263c";
            background_color = "15141b";
          };
        };
      };

      home = {
        username = "suteki";
        homeDirectory = "/home/suteki";
        stateVersion = "26.05";
      };
    };

}
