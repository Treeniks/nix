{ self, ... }:
{
  flake.nixosModules.stackGui = {
    imports = [
      self.nixosModules.commonGui
      self.nixosModules.stackPipewire

      self.nixosModules.niri
      self.nixosModules.greetdNiriReGreet
      self.nixosModules.virtualisationGui

      self.nixosModules.noctalia
      self.nixosModules.nemo

      self.nixosModules.gtkqtTheme
      self.nixosModules.noctaliaDynamicTheme
    ];
  };

  flake.nixosModules.stackPipewire = {
    imports = [
      self.nixosModules.pipewire
      self.nixosModules.pipewireClockRates
      self.nixosModules.pipewireVBCable
      self.nixosModules.pipewireVirtualSurround
    ];
  };

  flake.homeModules.stackGui = {
    imports = [
      self.homeModules.commonGui
      self.homeModules.commonPackagesGui
      self.homeModules.defaultAppsGui

      self.homeModules.mpv
      self.homeModules.fuzzel
      self.homeModules.kitty
      self.homeModules.sublime
      self.homeModules.zed

      self.homeModules.noctalia
      self.homeModules.nemo

      self.homeModules.gtkqtTheme
      self.homeModules.noctaliaDynamicTheme
    ];
  };
}
