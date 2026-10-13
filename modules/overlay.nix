{ inputs, self, ... }:
{
  # this overlay exists so I can easily "downgrade" apps whenever latest nixpkgs-unstable acts up
  flake.overlays.nixpkgs-weekly =
    final: prev:
    let
      pkgsWeekly = (import inputs.nixpkgs-weekly { system = final.stdenv.hostPlatform.system; });
    in
    {
      inherit (pkgsWeekly)
        # filen-desktop
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
