{
  flake.homeModules.yazi =
    { config, lib, ... }:
    {
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        shellWrapperName = "yy";

        theme = lib.mkIf config.my.noctalia-themeing {
          flavor = {
            dark = "noctalia";
            light = "noctalia";
          };
        };
      };

      catppuccin.yazi.enable = !config.my.noctalia-themeing;
      xdg.configFile."yazi/theme.toml".force = true;
    };
}
