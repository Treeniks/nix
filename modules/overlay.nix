{ inputs, self, ... }:
{
  # this overlay exists so I can easily "downgrade" apps whenever latest nixpkgs-unstable acts up
  flake.overlays.nixpkgs-weekly =
    final: prev:
    let
      pkgsWeekly = (import inputs.nixpkgs-weekly { system = final.stdenv.hostPlatform.system; });
      pkgsStable = (import inputs.nixpkgs-stable { system = final.stdenv.hostPlatform.system; });
    in
    {
      inherit (pkgsWeekly)
        # filen-desktop
        ;
      inherit (pkgsStable)
        # they removed it for a few days and it has since been readded
        # for some reason nixpkgs stable already includes it again, while unstable does not...
        brave
        brave-origin
        ;
    };

  den.aspects.nixpkgsWeekly = {
    nixos = {
      nixpkgs.overlays = [ self.overlays.nixpkgs-weekly ];
    };
    homeManager = {
      nixpkgs.overlays = [ self.overlays.nixpkgs-weekly ];
    };
  };
}
