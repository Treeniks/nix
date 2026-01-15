{ inputs, pkgs, ... }:
{
  # should get fixed soon(TM)
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  home.packages = with pkgs; [
    sublime4
    sublime-merge
  ];
  # xdg.configFile."sublime-text/Packages/User".source = "${inputs.dotfiles}/sublime/User";
  xdg.configFile."sublime-text/Packages/Vinimum".source = inputs.sublime-vinimum;
}
