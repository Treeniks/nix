{ pkgs }:
pkgs.writeScriptBin "animemode" ''
  #!${pkgs.fish}/bin/fish
  switch $argv[1]
    case on
      noctalia msg nightlight-disable

      niri msg output HDMI-A-1 scale 2
      niri msg output DP-1 off
      niri msg output DP-2 off
    case off
      niri msg output HDMI-A-1 scale 1.5
      niri msg output DP-1 on
      niri msg output DP-2 on

      noctalia msg nightlight-enable
  end
''
