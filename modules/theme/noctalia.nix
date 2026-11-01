{ den, ... }:
{
  den.aspects.noctaliaDynamicTheme = {
    includes = [
      den.aspects.umbrielNoctalia

      den.aspects.niriNoctalia
      den.aspects.gtkNoctalia
      den.aspects.fuzzelNoctalia
      den.aspects.kittyNoctalia
      den.aspects.yaziNoctalia
    ];
  };

  den.aspects.umbrielNoctalia.homeManager = {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "umbriel" ];
    programs.umbriel.settings.include.optional.files = [ "~/.config/umbriel/noctalia.toml" ];
  };

  den.aspects.niriNoctalia = {
    nixos = {
      wrappers.niri.extraSettings = [
        {
          include = [
            { optional = true; }
            "~/.config/niri/noctalia.kdl"
          ];
        }
      ];
    };

    homeManager = {
      programs.noctalia.settings.theme.templates.builtin_ids = [ "niri" ];
    };
  };

  den.aspects.gtkNoctalia = {
    homeManager = { pkgs, ... }: {
      programs.noctalia.settings.theme.templates.builtin_ids = [
        "gtk3"
        "gtk4"
      ];

      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
    };
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
