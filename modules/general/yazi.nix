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

        settings = {
          opener = {
            edit = [
              {
                # prevent nested neovims if yazi is run inside a neovim
                run = ''
                  if [ -n "$NVIM" ]; then
                    nvim --server "$NVIM" --remote %s
                  else
                    $EDITOR %s
                  fi
                '';
                block = true;
                orphan = true;
                desc = "Open in Neovim";
              }
            ];

            extract = [
              {
                run = "ya pub extract --list %s";
                desc = "Extract here";
              }
            ];
          };
        };

        initLua = ''
          require("session"):setup {
            sync_yanked = true,
          }
        '';
      };

      catppuccin.yazi.enable = !config.my.noctalia-themeing;
      xdg.configFile."yazi/theme.toml".force = true;
    };
}
