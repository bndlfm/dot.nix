{ lib, ... }:{
  programs.ranger = {
    enable = true;
    plugins = [
      {
        name = "ranger_devicons";
        src = builtins.fetchFromGithub {
          owner = "alexanderjeurissen";
          repor = "ranger_devicons";
          rev = lib.fakeSha256;
        };
      }
      {
        name = "ranger-devicons2";
        src = builtins.fetchFromGitHub {
          owner = "cdump";
          repo = "ranger-devicons2";
          rev = lib.fakeSha256;
        };
      }
    ];
  };
}
