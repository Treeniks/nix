{ inputs, ... }:
{
  flake.nixosModules.theme = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];

    catppuccin = {
      autoEnable = false;
      enable = true;
      accent = "lavender";
      flavor = "mocha";
    };
  };

  flake.homeModules.theme = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      autoEnable = false;
      enable = true;
      accent = "lavender";
      flavor = "mocha";

      cursors.enable = true;
    };
  };
}
