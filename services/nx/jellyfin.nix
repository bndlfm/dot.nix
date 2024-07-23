{ ... }:{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/.jellyfin/data";
    cacheDir = "/media/.jellyfin/cache";
    configDir = "/media/.jellyfin/config";
  };
  services.jellyseerr.enable = false;
}
