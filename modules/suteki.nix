{ den, treeniks, ... }:
{
  # gives us auto include for all "suteki" users
  den.aspects.suteki.includes = [ treeniks.suteki ];

  treeniks.suteki = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "fish")

      treeniks.common
      treeniks.common.pkgs
      treeniks.default-apps

      # we have fonts here, as they may be used for things like TeX
      # (so they're not exclusive to gui installations)
      treeniks.fonts
      treeniks.gpg
      treeniks.virtualisation

      treeniks.theme

      # terminal
      treeniks.fish
      treeniks.neovim
      treeniks.helix
      treeniks.yazi
    ];

    # also covers root, which den.batteries.user-shell doesn't touch
    nixos = { pkgs, ... }: {
      users.defaultUserShell = pkgs.fish;
    };

    user.extraGroups = [
      "video"
      "audio"
    ];
  };

  treeniks.suteki.gui.includes = [
    treeniks.common.gui
    treeniks.common.pkgs.gui
    treeniks.default-apps.gui
    treeniks.virtualisation.gui

    treeniks.pipewire

    treeniks.niri
    treeniks.greetd.niri-regreet

    treeniks.noctalia
    treeniks.umbriel

    treeniks.theme.cursors
    treeniks.theme.gtkqt
    treeniks.theme.noctalia

    # apps
    treeniks.fuzzel
    treeniks.kitty
    treeniks.nemo
    treeniks.mpv
    treeniks.sublime
    treeniks.zed
    treeniks.firefox
    treeniks.discord
  ];
}
