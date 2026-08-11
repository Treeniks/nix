{
  inputs,
  den,
  ...
}:
let
  hostname = "Shincha";
  system = "aarch64-darwin";
in
{
  den.homes.${system}."suteki@${hostname}" = { };
  den.aspects.suteki.provides.${hostname}.includes = [ den.aspects.${hostname} ];

  den.aspects.${hostname} = {
    includes = [
      den.aspects.common

      den.aspects.fish
      den.aspects.neovim
      den.aspects.helix
      den.aspects.yazi

      den.aspects.mpv
      den.aspects.kitty
      den.aspects.zed
    ];

    homeManager = { pkgs, lib, ... }: {
      wrappers.neovim.settings.config_directory = lib.mkForce "/Users/suteki/nix/modules/components/nvim/";

      # Now ideally we fix up commonPackages and the like to be darwin-friendly
      # but I use macos so rarely that it's kind of not worth it.
      #
      # So instead, we just kinda...copy it here as needed.

      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      catppuccin = {
        autoEnable = false;
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };

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

        neovide.enable = true;
        obsidian.enable = true;
      };

      home.packages = with pkgs; [
        nixfmt
        nixd
      ];

      home = {
        username = "suteki";
        homeDirectory = "/Users/suteki";
        stateVersion = "26.05";
      };
    };
  };
  #
}
