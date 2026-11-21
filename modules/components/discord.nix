{ treeniks, ... }:
{
  treeniks.discord = {
    includes = [ treeniks.pipewire.fuck-discord ];

    homeManager = { pkgs, lib, ... }: {
      # discord is only packaged for x86_64
      programs.discord = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.discord) {
        enable = true;
        settings = {
          "MINIMIZE_TO_TRAY" = false;
          "OPEN_ON_STARTUP" = false;
        };
      };
    };
  };

  treeniks.pipewire.fuck-discord.nixos = { pkgs, lib, ... }: {
    services.pipewire = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.discord) {
      extraConfig.pipewire = {
        # Disallow discord from changing volumes.
        # Discord is so fucking shit, that it will randomly put my microphone to 100% volume, destroying the ears of my friends.
        # Fuck you discord. Fuck you.
        wireplumber.extraConfig = {
          "fuck-discord" = {
            "access.rules" = [
              {
                matches = [ { "application.process.binary" = ".Discord-wrapped"; } ];
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
