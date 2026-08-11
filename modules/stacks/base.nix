{ den, ... }:
{
  den.aspects.stackBase.includes = [
    den.aspects.common
    den.aspects.commonPackages
    den.aspects.defaultApps

    # we have fonts here, as they may be used for things like TeX
    # (so they're not exclusive to gui installations)
    den.aspects.fonts
    den.aspects.gpg
    den.aspects.virtualisation

    den.aspects.theme
    den.aspects.fish
    den.aspects.neovim
    den.aspects.helix
    den.aspects.yazi
  ];
}
