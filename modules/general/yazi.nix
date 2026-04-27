{
  flake.homeModules.yazi = {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "yy";

      theme = {
        flavor = {
          dark = "noctalia";
          light = "noctalia";
        };
      };
    };

    catppuccin.yazi.enable = false;
    xdg.configFile."yazi/theme.toml".force = true;
  };

  perSystem.wrappers.packages.noctalia-shell-yazi = true;
  flake.wrappers.noctalia-shell-yazi =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

      settings = {
        templates = {
          activeTemplates = [
            {
              id = "yazi";
              enabled = true;
            }
          ];
        };
      };
    };
}
