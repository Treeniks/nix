{ den, ... }:
{
  den.aspects.noctaliaDynamicTheme = {
    includes = [
      den.aspects.niriNoctalia
      den.aspects.fuzzelNoctalia
      den.aspects.kittyNoctalia
      den.aspects.yaziNoctalia
    ];
  };

  den.aspects.niriNoctalia.nixos = {
    wrappers.niri.extraSettings = [
      {
        include = [
          { optional = true; }
          "~/.config/niri/noctalia.kdl"
        ];
      }
    ];
  };

  den.aspects.niriNoctalia.homeManager = {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "niri" ];
  };

  den.aspects.fuzzelNoctalia.homeManager = {
    programs.noctalia.settings.theme.templates.community_ids = [ "fuzzel" ];
    wrappers.fuzzel.settings.main.include = "~/.config/fuzzel/themes/noctalia";
  };

  den.aspects.kittyNoctalia.homeManager = { lib, ... }: {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "kitty" ];
    wrappers.kitty.themeFile = lib.mkForce null;
    wrappers.kitty.settings.include = "~/.config/kitty/themes/noctalia.conf";
  };

  den.aspects.yaziNoctalia.homeManager = { lib, ... }: {
    programs.noctalia.settings.theme.templates.community_ids = [ "yazi" ];
    catppuccin.yazi.enable = lib.mkForce false;
    programs.yazi.theme.flavor = {
      dark = "noctalia";
      light = "noctalia";
    };
  };
}
