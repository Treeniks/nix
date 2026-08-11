{
  den.aspects.defaultApps.nixos = {
    environment.sessionVariables.EDITOR = "nvim";
  };

  den.aspects.defaultAppsGui.homeManager = {
    xdg.mimeApps = {
      enable = true;
      defaultApplications =
        let
          editor = "sublime_text.desktop";
          # editor = "neovide.desktop";
          # editor = "Helix.desktop";

          browser = "brave-browser.desktop";
          image = "org.gnome.eog.desktop";
          video = "mpv.desktop";
          audio = "mpv.desktop";
          pdf = "org.gnome.Evince.desktop";
        in
        {
          # see https://mimetype.io/all-types
          "text/javascript" = editor;
          "text/markdown" = editor;
          "text/plain" = editor;
          "text/x-asm" = editor;
          "text/x-c" = editor;
          "text/x-fortran" = editor;
          "text/x-java-source" = editor;
          "text/x-pascal" = editor;
          "text/x-python" = editor;

          "text/html" = browser;

          "image/bmp" = image;
          "image/gif" = image;
          "image/jpeg" = image;
          "image/png" = image;
          "image/tiff" = image;
          "image/webp" = image;

          "video/mp2t" = video; # .ts
          "video/mp4" = video;
          "video/mpeg" = video;
          "video/ogg" = video;
          "video/quicktime" = video;
          "video/webm" = video;
          "video/x-m4v" = video;
          "video/x-matroska" = video;

          "audio/aac" = audio;
          "audio/flac" = audio;
          "audio/mp4" = audio;
          "audio/mpeg" = audio;
          "audio/ogg" = audio;
          "audio/opus" = audio;
          "audio/wav" = audio;
          "audio/webm" = audio;
          "audio/x-matroska" = audio;
          "audio/x-ms-wma" = audio;

          "application/pdf" = pdf;
        };
    };
  };
}
