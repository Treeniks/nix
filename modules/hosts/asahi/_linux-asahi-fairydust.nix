# copied from https://github.com/nix-community/nixos-apple-silicon/blob/main/apple-silicon-support/packages/linux-asahi/default.nix
# becaue I couldn't figure out how to override the src
{
  lib,
  callPackage,
  linuxPackagesFor,
  _kernelPatches ? [ ],
}@args:

let
  extraArgs = lib.removeAttrs args [
    "lib"
    "callPackage"
    "linuxPackagesFor"
    "_kernelPatches"
  ];

  linux-asahi-pkg =
    {
      stdenv,
      lib,
      fetchFromGitHub,
      buildLinux,
      ...
    }:
    buildLinux (
      lib.recursiveUpdate rec {
        inherit stdenv lib;

        pname = "linux-asahi";
        version = "7.1.13";
        modDirVersion = version;
        extraMeta.branch = "fairydust";

        src = fetchFromGitHub {
          owner = "AsahiLinux";
          repo = "linux";
          rev = "ce9f2eba72c061a50b2d790450e90af3439d8c24";
          hash = "sha256-W3yMSUe6xa+M/X0k86kbCS4g3d7jJmO3WV9L/5rQRhI=";
        };

        kernelPatches = [
          {
            name = "Asahi config";
            patch = null;
            structuredExtraConfig = with lib.kernel; {
              # Needed for GPU
              ARM64_16K_PAGES = yes;

              ARM64_MEMORY_MODEL_CONTROL = yes;
              ARM64_ACTLR_STATE = yes;

              # Might lead to the machine rebooting if not loaded soon enough
              APPLE_WATCHDOG = yes;

              # === fairydust ===
              APPLE_MAILBOX = yes;

              APPLE_RTKIT = yes;
              APPLE_RTKIT_HELPER = yes;
              RUST_APPLE_RTKIT = yes;
              RUST_FW_LOADER_ABSTRACTIONS = yes;
              # === ========= ===

              # Can not be built as a module, defaults to no
              APPLE_M1_CPU_PMU = yes;

              # Defaults to 'y', but we want to allow the user to set options in modprobe.d
              HID_APPLE = module;

              APPLE_PMGR_MISC = yes;
              APPLE_PMGR_PWRSTATE = yes;
            };
            features.rust = true;
          }
        ]
        ++ _kernelPatches;
      } extraArgs
    );

  linux-asahi = callPackage linux-asahi-pkg { };
in
lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)
