{ treeniks, ... }:
{
  treeniks.theme.noctalia.includes = [
    treeniks.umbriel.noctalia
    treeniks.niri.noctalia
    treeniks.gtk.noctalia
    treeniks.fuzzel.noctalia
    treeniks.kitty.noctalia
    treeniks.yazi.noctalia
  ];

  treeniks.umbriel.noctalia.homeManager = {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "umbriel" ];
    programs.umbriel.settings.include.optional.files = [ "~/.config/umbriel/noctalia.toml" ];
  };

  treeniks.niri.noctalia = {
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

  treeniks.gtk.noctalia.homeManager = { pkgs, ... }: {
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

  treeniks.fuzzel.noctalia.homeManager = {
    programs.noctalia.settings.theme.templates.community_ids = [ "fuzzel" ];
    wrappers.fuzzel.settings.main.include = "~/.config/fuzzel/themes/noctalia";
  };

  treeniks.kitty.noctalia.homeManager = { lib, ... }: {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "kitty" ];
    wrappers.kitty.themeFile = lib.mkForce null;
    wrappers.kitty.settings.include = "~/.config/kitty/themes/noctalia.conf";
  };

  treeniks.yazi.noctalia.homeManager = { lib, ... }: {
    programs.noctalia.settings.theme.templates.community_ids = [ "yazi" ];
    catppuccin.yazi.enable = lib.mkForce false;
    programs.yazi.theme.flavor = {
      dark = "noctalia";
      light = "noctalia";
    };
  };
}
