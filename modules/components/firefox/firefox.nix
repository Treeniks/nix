{
  den.aspects.firefox.homeManager = {
    programs.firefox = {
      enable = true;
      profiles.nix = {
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };
}
