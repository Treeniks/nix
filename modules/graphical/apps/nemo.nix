{
  flake.homeModules.nemo =
    { pkgs, lib, ... }:
    let
      action_text =
        { name, exec }:
        ''
          [Nemo Action]
          Name=${name}
          Exec=${exec} %F
          Terminal=true
          Selection=notnone
          Extensions=any;
        '';

      ffmpeg-ss = pkgs.writeScript "ffmpeg-ss" ''
        #!${lib.getExe pkgs.fish}

        read -P "ss " time

        for file in $argv
          set dir (path dirname "$file")
          set base (path basename --no-extension "$file")
          set ext (path extension "$file")

          ${lib.getExe pkgs.ffmpeg} \
            -ss $time \
            -i "$file" \
            -map 0 \
            -c copy \
            -avoid_negative_ts make_zero \
            "$dir/$base - shortened$ext"
        end
      '';

      ffmpeg-to = pkgs.writeScript "ffmpeg-to" ''
        #!${lib.getExe pkgs.fish}

        read -P "to " time

        for file in $argv
          set dir (path dirname "$file")
          set base (path basename --no-extension "$file")
          set ext (path extension "$file")

          ${lib.getExe pkgs.ffmpeg} \
            -i "$file" \
            -to $time \
            -map 0 \
            -c copy \
            "$dir/$base - shortened$ext"
        end
      '';

      ffmpeg-volume = pkgs.writeScript "ffmpeg-volume" ''
        #!${lib.getExe pkgs.fish}

        echo "1.0 = unchanged volume"

        read -P "Volume for Stream 1 (Microphone): " v1
        read -P "Volume for Stream 2 (VOIP): " v2
        read -P "Volume for Stream 3 (System Primary): " v3
        read -P "Volume for Stream 4 (System Secondary): " v4

        for file in $argv
          set dir (path dirname "$file")
          set base (path basename --no-extension "$file")
          set ext (path extension "$file")

          ${lib.getExe pkgs.ffmpeg} \
            -i "$file" \
            -filter_complex "[0:a:1][0:a:2][0:a:3][0:a:4]amerge=inputs=4,pan=stereo|c0=$v1*c0+$v2*c2+$v3*c4+$v4*c6|c1=$v1*c1+$v2*c3+$v3*c5+$v4*c7[amerge]" \
            -map 0:v:0 \
            -map "[amerge]" \
            -map 0:a:1 \
            -map 0:a:2 \
            -map 0:a:3 \
            -map 0:a:4 \
            -c:v copy \
            -c:a:0 libopus -b:a 192k \
            -c:a:1 copy \
            -c:a:2 copy \
            -c:a:3 copy \
            -c:a:4 copy \
            "$dir/$base - volume adjusted($v1;$v2;$v3;$v4)$ext"
        end
      '';
    in
    {
      # make nemo's "Open in Termianl" action open kitty
      dconf.settings = {
        "org/cinnamon/desktop/applications/terminal" = {
          exec = "kitty";
        };
      };

      home.packages = [ pkgs.nemo-with-extensions ];

      # the following are nemo right click actions I use to manage my OBS replay-buffer recorded videos
      xdg.dataFile."nemo/actions/ffmpeg-ss.nemo_action" = {
        enable = true;
        text = action_text {
          name = "ffmpeg ss";
          exec = ffmpeg-ss;
        };
      };

      xdg.dataFile."nemo/actions/ffmpeg-to.nemo_action" = {
        enable = true;
        text = action_text {
          name = "ffmpeg to";
          exec = ffmpeg-to;
        };
      };

      xdg.dataFile."nemo/actions/ffmpeg-volume.nemo_action" = {
        enable = true;
        text = action_text {
          name = "ffmpeg adjust volume";
          exec = ffmpeg-volume;
        };
      };
    };
}
