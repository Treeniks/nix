{
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
