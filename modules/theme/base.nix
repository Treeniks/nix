{ inputs, den, ... }:
{
  den.aspects.theme = {
    includes = [ den.aspects.cursors ];

    nixos = {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];

      catppuccin = {
        autoEnable = false;
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };
    };

    homeManager = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        autoEnable = false;
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };
    };
  };

  den.aspects.cursors = {
    # NOTE: Cursor theme is also set inside niri config
    # and often deviates from the global catppuccin settings above.
    # Makes cursors switch theme occassionally but I don't care enough to fix it.

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        catppuccin-cursors.mochaLavender
        catppuccin-cursors.mochaMaroon
      ];
    };

    homeManage = {
      home.pointerCursor.enable = true;
      catppuccin.cursors.enable = true;
    };
  };
}
