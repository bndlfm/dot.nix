{ pkgs, ...}:{
  services = {
    espanso = {
      enable = true;
      package = pkgs.espanso;
      matches = {
        base = {
          matches = [
            { trigger = ":fflb"; replace = "firefliesandlightningbugs@gmail.com"; }
          ];
        };
      };
    };
  };
}
