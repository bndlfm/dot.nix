{ pkgs, ... }: {
  services = {
    sunshine = {
      enable = true;
      package = pkgs.sunshine;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    caddy = {
      virtualHosts."sunshine.munchkin-sun.ts.net".extraConfig = ''
        bind tailscale/sunshine:47990
        reverse_proxy localhost:47990
      '';
    };
  };
}
