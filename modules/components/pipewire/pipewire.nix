{ treeniks, ... }:
{
  treeniks.pipewire = {
    includes = [
      treeniks.pipewire.clock-rates
      treeniks.pipewire.vb-cable
      treeniks.pipewire.virtual-surround
    ];

    nixos = {
      services.pipewire = {
        enable = true;

        pulse.enable = true;
        wireplumber.enable = true;
        alsa.enable = true;
      };
    };
  };

  treeniks.pipewire.clock-rates.nixos = {
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

  treeniks.pipewire.vb-cable.nixos = {
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
