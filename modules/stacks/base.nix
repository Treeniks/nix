{ self, ... }:
{
  flake.nixosModules.stackBase = {
    imports = [
      self.nixosModules.common
      self.nixosModules.commonPackages
      self.nixosModules.defaultApps

      # we have fonts here, as they may be used for things like TeX
      # (so they're not exclusive to gui installations)
      self.nixosModules.fonts
      self.nixosModules.gpg
      self.nixosModules.virtualisation

      self.nixosModules.theme
      self.nixosModules.fish
    ];
  };

  flake.homeModules.stackBase = {
    imports = [
      self.homeModules.common
      self.homeModules.commonPackages

      self.homeModules.theme
      self.homeModules.fish
      self.homeModules.neovim
      self.homeModules.helix
      self.homeModules.yazi
    ];
  };
}
