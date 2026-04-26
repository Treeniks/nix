{ self, ... }:
{
  flake.nixosModules.stackPipewireFull = {
    imports = [
      self.nixosModules.pipewireBase
      self.nixosModules.pipewireClockRates
      self.nixosModules.pipewireVBCable
      self.nixosModules.pipewireVirtualSurround
    ];
  };

  flake.nixosModules.pipewireBase = {
    services.pipewire = {
      enable = true;

      pulse.enable = true;
      wireplumber.enable = true;
      alsa.enable = true;

      extraConfig.pipewire = {
        # Disallow discord from changing volumes.
        # Discord is so fucking shit, that it will randomly put my microphone to 100% volume, destroying the ears of my friends.
        # Fuck you discord. Fuck you.
        wireplumber.extraConfig = {
          "fuck-discord" = {
            "access.rules" = [
              {
                matches = [
                  { "application.process.binary" = ".Discord-wrapped"; }
                ];
                actions = {
                  update-props = {
                    default_permissions = "rx";
                  };
                };
              }
            ];
          };
        };
      };
    };
  };
}
