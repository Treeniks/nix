{ pkgs, ... }:
let
  niriConfig = pkgs.writeText "greetd-niri-config" (builtins.readFile ./greetd-niri.kdl);
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "dbus-run-session ${pkgs.niri}/bin/niri --config ${niriConfig}";
      };
    };
  };
}
