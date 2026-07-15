{
  flake.overlays.asahi-fairydust = final: prev: {
    linux-asahi = final.callPackage ./_linux-asahi-fairydust.nix { };
  };
}
