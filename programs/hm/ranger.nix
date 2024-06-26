{ ... }:{
  programs.ranger = {
    enable = true;
    plugins = [
      {
        name = "ranger_devicons";
        src = builtins.fetchGit {
          url = "https://github.com/alexanderjeurissen/ranger_devicons";
        };
      }
      {
        name = "ranger-devicons2";
        src = builtins.fetchGit {
          url = "https://github.com/cdump/ranger-devicons2";
        };
      }
    ];
  };
}
