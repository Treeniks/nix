{ inputs, ... }:
{
  flake.homeModules.sublime = { pkgs, ... }: {
    home.packages = with pkgs; [
      # sublime4 is broken because of openssl shit
      sublime4-dev
      sublime-merge
    ];

    # xdg.configFile."sublime-text/Packages/User".source = "${inputs.dotfiles}/sublime/User";
    xdg.configFile."sublime-text/Packages/Vinimum".source = inputs.sublime-vinimum;
  };
}
