{
  flake.wrappers.fuzzel =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.fuzzel ];

      settings = {
        main = {
          # noctalia theme include
          # mostly overwrites the colors defined below
          include = "~/.config/fuzzel/themes/noctalia";

          font = "Maple Mono Normal:size=15";
          use-bold = true;

          match-mode = "fzf";
          match-counter = true;

          width = 50;
          lines = 20;
        };
        colors = {
          background = "313244D0";
          text = "cdd6f4ff";
          prompt = "a6adc8ff";
          # TODO I don't get how to do this
          # placeholder =;
          input = "cdd6f4ff";
          match = "f38ba8ff";
          selection = "b4befeff";
          selection-text = "11111bff";
          selection-match = "a2113aff";
          counter = "fab387ff";
          border = "a277ffff";
        };

        border = {
          width = 2;
          radius = 20;
          selection-radius = 10;
        };
      };
    };

  perSystem.wrappers.packages.noctalia-shell-fuzzel = true;
  flake.wrappers.noctalia-shell-fuzzel =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.noctalia-shell ];

      settings = {
        templates = {
          activeTemplates = [
            {
              id = "fuzzel";
              enabled = true;
            }
          ];
        };
      };
    };
}
