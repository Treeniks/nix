{ pkgs }:
pkgs.writeScriptBin "animemode" ''
  #!${pkgs.fish}/bin/fish
  switch $argv[1]
    case on
      # HACK until noctalia v5 is out
      # 1st toggle => Normal mode
      # 2nd toggle => Disabled
      noctalia-shell ipc call nightLight toggle
      noctalia-shell ipc call nightLight toggle

      niri msg output HDMI-A-1 scale 2
      niri msg output DP-1 off
      niri msg output DP-2 off
    case off
      niri msg output HDMI-A-1 scale 1.5
      niri msg output DP-1 on
      niri msg output DP-2 on

      # 3rd toggle => Enabled
      noctalia-shell ipc call nightLight toggle
  end
''
