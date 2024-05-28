{
  pkgs,
  config,
  ...
}:{
  environment.systemPackages = with pkgs; [ tailscale ];

  services = {
    networkd-dispatcher = {
      enable = true;
      rules = {
        "tailscale" = {
          onState = [ "routable" ];
          script = ''
            #!${pkgs.runtimeShell}
            echo "Fixing UDP-GRO for Tailscale...."
            NETDEV=$(ip route show 0/0 | cut -f5 -d' ')
            ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off

            exit 0
          '';
        };
      };
    };
  };

  services.tailscale = {
    enable = true;
    port = 41641;
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ config.services.tailscale.port ];
  };

  #systemd.services.tailscale-autoconnect = {
  #  description = "Automatic connection to Tailscale";

  #  # make sure tailscale is running before trying to connect to tailscale
  #  after = [ "network-pre.target" "tailscale.service" ];
  #  wants = [ "network-pre.target" "tailscale.service" ];
  #  wantedBy = [ "multi-user.target" ];

  #  serviceConfig.Type = "oneshot";

  #  script = with pkgs; /* bash */ ''
  #    # wait for tailscaled to settle
  #    sleep 2
  #    # check if we are already authenticated to tailscale
  #    status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"

  #    if [ $status = "Running" ]; then # if so, then do nothing
  #      exit 0
  #    fi

  #    # otherwise authenticate with tailscale
  #    ### ..../bin/tailscale up -authkey tskey-examplekeyhere # get this from admin console
  #    ${tailscale}/bin/tailscale up --accept-routes --advertise-routes=192.168.1.0/24
  #  '';
  #};
}
