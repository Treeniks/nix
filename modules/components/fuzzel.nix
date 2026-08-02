{ self, ... }:
{
  flake.homeModules.fuzzel = {
    imports = [ self.wrappers.fuzzel.install ];
    wrappers.fuzzel.enable = true;
  };

  flake.wrappers.fuzzel = { wlib, ... }: {
    imports = [ wlib.wrapperModules.fuzzel ];

    settings = {
      main = {
        font = "Maple Mono:size=15";
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
}
