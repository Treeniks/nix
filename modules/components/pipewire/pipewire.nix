{
  flake.nixosModules.pipewire = {
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

  flake.nixosModules.pipewireClockRates = {
    services.pipewire = {
      extraConfig.pipewire = {
        "10-rates" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [
              44100
              48000
              88200
              96000
            ];
          };
        };
      };
    };
  };

  flake.nixosModules.pipewireVBCable = {
    services.pipewire = {
      extraConfig.pipewire = {
        # loopback cable
        # allows using system audio as a microphone
        "vb-cable" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-loopback";
              args = {
                "node.description" = "Virtual Audio Cable";
                "capture.props" = {
                  "node.name" = "vbcable_sink";
                  "media.class" = "Audio/Sink";
                };
                "playback.props" = {
                  "node.name" = "vbcable_source";
                  "media.class" = "Audio/Source";
                };
              };
            }
          ];
        };
      };
    };
  };
}
