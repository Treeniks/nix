{
  flake.nixosModules.theme = {
    catppuccin = {
      accent = "lavender";
      flavor = "mocha";

      # global enable
      enable = true;
    };
  };

  flake.homeModules.theme = {
    catppuccin = {
      enable = true;
      accent = "lavender";
      flavor = "mocha";
    };
  };
}
