let
  shellAbbrs = {
    nrs = {
      position = "anywhere";
      expansion = "nixos-rebuild switch --flake ~/nix/";
    };
    ngc = {
      position = "anywhere";
      expansion = "nix-collect-garbage --delete-older-than 7d";
    };
    hms = "home-manager switch --flake ~/nix/";
  };

  shellAliases = {
    ls = "eza -la --color=always";
    less = "less -Ri";
    cat = "bat";
  };

  interactiveShellInit = ''
    # https://github.com/fish-shell/fish-shell/issues/11251
    set fish_color_command blue

    function fish_user_key_bindings
      # needed for the mode indicator to work
      fish_vi_key_bindings

      fish_default_key_bindings -M insert
      fish_vi_key_bindings --no-erase insert

      # bring back old 3.X behavior
      bind -M insert ctrl-n down-or-search
    end
  '';

  # from https://yazi-rs.github.io/docs/quick-start#shell-wrapper
  yaziFunction = ''
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
  '';
in
{
  flake.homeModules.fish = {
    programs.fish = {
      enable = true;

      shellInit = ''
        fish_add_path -g "$HOME/.cargo/bin/"
      '';

      inherit interactiveShellInit;

      inherit shellAbbrs;
      inherit shellAliases;

      # this happens by itself thanks to programs.yazi.enableFishIntegration
      # functions = {
      #   yy = yaziFunction;
      # };
    };
  };

  flake.wrappers.fish =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.fish ];

      runtimePkgs = [
        pkgs.yazi
        pkgs.starship
        pkgs.zoxide
      ];

      abbreviations = shellAbbrs;
      inherit shellAliases;

      configFile.content = ''
        if status is-interactive
          ${interactiveShellInit}
          starship init fish | source
          zoxide init fish --cmd d | source
        end

        function yy
          ${yaziFunction}
        end
      '';
    };
}
