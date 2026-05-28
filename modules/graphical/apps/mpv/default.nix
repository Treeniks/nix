{ self, ... }:
{
  flake.homeModules.mpv =
    { pkgs, ... }:
    {
      home.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.mpv
      ];
    };

  flake.wrappers.mpv =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.mpv ];

      "mpv.conf".path = ./mpv.conf;
      "mpv.input".path = ./input.conf;

      script = {
        uosc = {
          path = pkgs.mpvScripts.uosc;
          opts = {
            # default: line
            timeline_style = "bar";

            # keep timeline open when playing audio files
            timeline_persistency = "audio";

            controls = "menu,gap,subtitles,audio,video,editions,<stream>stream-quality,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen";
            volume = "left";

            # Can be: never, no-border, always
            top_bar = "always";
            # Can be: no, left, right
            top_bar_controls = "right";
            top_bar_persistency = "paused";

            destination_time = "total";

            # hide UI when mpv autohides the cursor
            autohide = "no";
          };
        };
        thumbfast.path = pkgs.mpvScripts.thumbfast;
      };
    };
}
