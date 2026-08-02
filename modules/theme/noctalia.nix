{ self, ... }:
{
  flake.nixosModules.noctaliaDynamicTheme = {
    imports = [ self.nixosModules.niriNoctalia ];
  };

  flake.nixosModules.niriNoctalia = {
    wrappers.niri.extraSettings = [
      {
        include = [
          { optional = true; }
          "~/.config/niri/noctalia.kdl"
        ];
      }
    ];
  };

  flake.homeModules.noctaliaDynamicTheme = {
    imports = [
      self.homeModules.niriNoctalia
      self.homeModules.fuzzelNoctalia
      self.homeModules.kittyNoctalia
      self.homeModules.yaziNoctalia
    ];
  };

  flake.homeModules.niriNoctalia = {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "niri" ];
  };

  flake.homeModules.fuzzelNoctalia = {
    programs.noctalia.settings.theme.templates.community_ids = [ "fuzzel" ];
    wrappers.fuzzel.settings.main.include = "~/.config/fuzzel/themes/noctalia";
  };

  flake.homeModules.kittyNoctalia = { lib, ... }: {
    programs.noctalia.settings.theme.templates.builtin_ids = [ "kitty" ];
    wrappers.kitty.themeFile = lib.mkForce null;
    wrappers.kitty.settings.include = "~/.config/kitty/themes/noctalia.conf";
  };

  flake.homeModules.yaziNoctalia = { lib, ... }: {
    programs.noctalia.settings.theme.templates.community_ids = [ "yazi" ];
    catppuccin.yazi.enable = lib.mkForce false;
    programs.yazi.theme.flavor = {
      dark = "noctalia";
      light = "noctalia";
    };
  };
}
