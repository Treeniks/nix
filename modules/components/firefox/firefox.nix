{
  den.aspects.firefox.homeManager = {
    programs.firefox = {
      enable = true;
      profiles.nix = {
        userChrome = ./userChrome.css;
      };
    };
  };
}
