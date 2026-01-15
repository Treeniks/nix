{ pkgs, lib, ... }:
let
  # TODO display setup should be more configurable
  niriConfig = ''
    spawn-sh-at-startup "${lib.getExe pkgs.regreet}; ${lib.getExe pkgs.niri} msg action quit --skip-confirmation"
  ''
  + (builtins.readFile ./greetd-niri.kdl);
  niriConfigFile = pkgs.writeText "greetd-niri-config" niriConfig;
in
{
  programs.regreet = {
    enable = true;
    theme.name = "Catppuccin-GTK-Purple-Dark";
    cursorTheme.name = "catppuccin-mocha-lavender-cursors";
    iconTheme.name = "Catppuccin-Mocha";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # see also https://github.com/NixOS/nixpkgs/blob/1412caf7bf9e660f2f962917c14b1ea1c3bc695e/nixos/modules/programs/regreet.nix#L154
        command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.niri} --config ${niriConfigFile}";
      };
    };
  };
}
