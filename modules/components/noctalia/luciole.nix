{
  treeniks.luciole.homeManager = { inputs', ... }: {
    home.packages = [ inputs'.luciole.packages.default ];
  };
}
