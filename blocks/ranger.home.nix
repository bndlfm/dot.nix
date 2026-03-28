{ pkgs, ... }:{
  programs.ranger = {
    enable = true;
    plugins = [
      {
        name = "ranger_devicons";
        src = pkgs.fetchFromGitHub {
          owner = "alexanderjeurissen";
          repo = "ranger_devicons";
          rev = "f227f21";
          hash = "sha256-ck53eG+mGIQ706sUnEHbJ6vY1/LYnRcpq94JXzwnGTQ=";
        };
      }
      {
        name = "ranger-devicons2";
        src = pkgs.fetchFromGitHub {
          owner = "cdump";
          repo = "ranger-devicons2";
          rev = "94bdcc1";
          hash = "sha256-aJCIoDfzmOnzMLlbOe+dy6129n5Dc4OrefhHnPsgI8k=";
        };
      }
    ];
  };
}
