{ pkgs, dotfiles, sublime-vinimum, ... }: {
  home.packages = with pkgs; [
    sublime4
    sublime-merge
  ];
  xdg.configFile."sublime-text/Packages/User".source = "${dotfiles}/sublime/User";
  xdg.configFile."sublime-text/Packages/Vinimum".source = sublime-vinimum;
}
