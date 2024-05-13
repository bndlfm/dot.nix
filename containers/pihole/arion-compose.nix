{ pkgs, ... }:{
  project.name = "pihole";
  services.pihole = {
    service = {
      image = "pihole/pihole";
      volumes = [
        "${toString ./.}/pihole:/etc/pihole"
        "${toString ./.}/dnsmasq.d:/etc/dnsmasq.d"
      ];
      environment = {
        WEB_PORT = "8053";
        TZ = "America/Chicago";
      };
      network_mode = "host";
    };
  };
}
