{
  lib,
  config,
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [
    ethtool
    tailscale
    networkd-dispatcher
  ];

  services = {
    networkd-dispatcher = {
      enable = true;
      rules = {
        "50-tailscale" = {
          onState = ["routable"];
          script = ''
            ${lib.getExe pkgs.ethtool} -K enp6s0 rx-udp-gro-forwarding on rx-gro-list off
          '';
        };
      };
    };
  };

  services.tailscale = {
    enable = true;
    port = 41641;
  };

  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts =
        [
          config.services.tailscale.port
          80
          443
        ];
    };
    interfaces."tailscale0" = {
      useDHCP = false;
      wakeOnLan.enable = true;
    };
  };

  systemd.services.tailscale-funnel = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; /* bash */ ''
      # wait for tailscaled to settle
      sleep 5
      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"

      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ### ..../bin/tailscale up -authkey tskey-examplekeyhere # get this from admin console
      ${tailscale}/bin/tailscale up --advertise-routes=192.168.1.0/24 --operator=neko
      ${tailscale}/bin/tailscale serve https:443 http:80

    '';
  };
}
