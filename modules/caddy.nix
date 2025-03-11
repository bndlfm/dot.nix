{ lib, pkgs, config, ...}:
let
  cfg = config._services.caddy;
in
  {
    options =
      {
        _services.caddy =
          {
            enable = lib.mkEnableOption "Enable my customized Caddy/Tailscale";
            hostname = lib.mkOption
              {
                type = lib.types.str;
                description = "Hostname for the Caddy virtual host (uses tailscale pc host name)";
                example = "Default: meow for https://meow.munchkin-sun.ts.net";
                default = "meow";
              };
            tailnetName = lib.mkOption
              {
                type = lib.types.str;
                description = "Tailscale tailnet name";
                example = "Default: munchkin-sun for https://meow.munchkin-sun.ts.net";
                default = "munchkin-sun";
              };


            jellyfin =
              {
                enable = lib.mkEnableOption "Enable Jellyfin reverse proxy";
                port = lib.mkOption
                  {
                    type = lib.types.port;
                    description = "Jellyfin HTTP port";
                    default = 8096;
                  };
                securePort = lib.mkOption
                  {
                    type = lib.types.port;
                    description = "Jellyfin HTTPS port";
                    default = 8920;
                  };

                subdomain = lib.mkOption
                  {
                    type = lib.types.str;
                    description = "Subdomain for Jellyfin (empty for main domain)";
                    default = "jellyfin";
                  };
              };


            vaultwarden =
              {
                enable = lib.mkEnableOption "Enable Vaultwarden reverse proxy";
                port = lib.mkOption
                  {
                    type = lib.types.port;
                    description = "Vaultwarden port";
                    default = 8222;
                  };
                subdomain = lib.mkOption
                  {
                    type = lib.types.str;
                    description = "Subdomain for Vaultwarden (empty for main domain)";
                    default = "vault";
                  };
              };
          };
      };



    config = lib.mkIf cfg._services.caddy.enable
      {
        services.caddy =
          {
            enable = true;
            virtualHosts = lib.mkMerge
              [
                # Jellyfin
                (
                  lib.mkIf cfg.jellyfin.enable
                    {
                      "${cfg.jellyfin.subdomain}.${cfg.hostname}.${cfg.tailnetName}.ts.net" =
                        {
                          extraConfig =
                            ''
                              # Handle HTTP traffic
                              @jellyfin_http {
                                not path /socket
                              }
                              reverse_proxy 127.0.0.1:${toString cfg.jellyfin.port}

                              # Handle secure HTTPS traffic
                              @jellyfin_https {
                                path /socket
                              }
                              reverse_proxy @jellyfin_https 127.0.0.1:${toString cfg.jellyfin.securePort}

                              # Special handling for Jellyfin's websockets
                              @websockets {
                                header Connection *Upgrade*
                                header Upgrade websocket
                              }
                              reverse_proxy @websockets 127.0.0.1:${toString cfg.jellyfin.port}
                            '';
                        };
                    }
                )

                # Vaultwarden
                (
                  lib.mkIf cfg.jellyfin.enable
                    {
                      "${cfg.vaultwarden.subdomain}.${cfg.hostname}.${cfg.tailnetName}.ts.net" =
                        {
                          extraConfig =
                            ''
                              reverse_proxy 127.0.0.1:${toString cfg.vaultwarden.port}
                            '';
                        };
                    }
                )
              ];
          };

        services.tailscale.permitCertUid = "caddy";
      };
  }
