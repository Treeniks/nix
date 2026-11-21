{ treeniks, ... }:
{
  treeniks.stackBase.includes = [
    treeniks.common
    treeniks.commonPackages
    treeniks.defaultApps

    # we have fonts here, as they may be used for things like TeX
    # (so they're not exclusive to gui installations)
    treeniks.fonts
    treeniks.gpg
    treeniks.virtualisation

    treeniks.theme
    treeniks.fish
    treeniks.neovim
    treeniks.helix
    treeniks.yazi
  ];
}
