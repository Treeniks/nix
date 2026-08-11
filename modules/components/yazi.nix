{ self, ... }:
let
  settings = {
    opener = {
      edit = [
        {
          # nested neovims
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
in
{
  den.aspects.yazi.homeManager = {
    # we use the home-manager module instead of the wrapper for two reasons:
    # 1. I couldn't be bothered manually setting up the catppuccin theme.
    #    I should do that someday anyways, just so the wrapper is themed, but it doesn't matter too much.
    # 2. Noctalia dynamic themeing doesn't work with the wrapper,
    #    as yazi doesn't seem to be very flexible when it comes to theme locations.
    catppuccin.yazi.enable = true;
    programs.yazi = {
      enable = true;
      inherit settings;
      inherit initLua;
    };
  };

  flake.wrappers.yazi = { wlib, ... }: {
    imports = [ wlib.wrapperModules.yazi ];
    settings.yazi = settings;
    inherit initLua;
  };
}
