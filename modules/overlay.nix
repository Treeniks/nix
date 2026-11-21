{ inputs, self, ... }:
{
  # this overlay exists so I can easily "downgrade" apps whenever latest nixpkgs-unstable acts up
  flake.overlays.nixpkgs-alts =
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
        # brave
        # brave-origin
        ;
    };

  treeniks.nixpkgsWeekly = {
    nixos = {
      nixpkgs.overlays = [ self.overlays.nixpkgs-alts ];
    };
    homeManager = {
      nixpkgs.overlays = [ self.overlays.nixpkgs-alts ];
    };
  };
}
