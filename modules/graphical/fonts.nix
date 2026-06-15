{
  flake.nixosModules.graphicalFonts =
    { pkgs, ... }:
    {
      fonts.enableDefaultPackages = true;
      fonts.packages = with pkgs; [
        # probably already included in default packages
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf

        nerd-fonts.jetbrains-mono
        jetbrains-mono
        julia-mono
        maple-mono.variable
        ioskeley-mono.normal

        roboto
        roboto-mono
        roboto-flex
        roboto-slab
        roboto-serif

        stix-two
      ];
    };
}
