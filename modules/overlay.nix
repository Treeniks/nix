{ inputs, self, ... }:
{
  # this overlay exists so I can easily "downgrade" apps whenever latest nixpkgs-unstable acts up
  flake.overlays.nixpkgs-alts =
    final: prev:
    let
      pkgs-weekly = (import inputs.nixpkgs-weekly { system = final.stdenv.hostPlatform.system; });
      pkgs-stable = (import inputs.nixpkgs-stable { system = final.stdenv.hostPlatform.system; });
    in
    {
      inherit (pkgs-weekly)
        # filen-desktop
        ;
      inherit (pkgs-stable)
        # brave
        # brave-origin
        ;
    };

  treeniks.nixpkgs-alts = {
    nixos.nixpkgs.overlays = [ self.overlays.nixpkgs-alts ];
    homeManager.nixpkgs.overlays = [ self.overlays.nixpkgs-alts ];
  };
}
