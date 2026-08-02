{
  flake.nixosModules.gpg = { pkgs, ... }: {
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-gnome3;
        settings = {
          default-cache-ttl = 7200;
          no-allow-external-cache = "";
        };
      };
    };
  };
}
