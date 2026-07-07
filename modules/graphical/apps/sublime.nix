{ inputs, ... }:
{
  flake.homeModules.sublime =
    { pkgs, ... }:
    {
      nixpkgs.config.problems.handlers = {
        sublimetext4.broken = "warn"; # or "ignore"
      };

      home.packages = with pkgs; [
        sublime4
        sublime-merge
      ];
      # xdg.configFile."sublime-text/Packages/User".source = "${inputs.dotfiles}/sublime/User";
      xdg.configFile."sublime-text/Packages/Vinimum".source = inputs.sublime-vinimum;
    };
}
