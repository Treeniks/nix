{
  flake.nixosModules.theme = {
    catppuccin = {
      autoEnable = true;
      enable = true;
      accent = "lavender";
      flavor = "mocha";
    };
  };

  flake.homeModules.theme = {
    catppuccin = {
      autoEnable = true;
      enable = true;
      accent = "lavender";
      flavor = "mocha";
    };
  };
}
