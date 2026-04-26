{
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
}
