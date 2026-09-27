{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      wayvr
      xrizer
    ];
  };

  services = {
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    wivrn = {
      enable = true;
      package = (pkgs.wivrn.override { cudaSupport = true; });
      openFirewall = true;
      autoStart = true; # Run WiVRn as a systemd service on startup
      config = {
        enable = true;
        json = {
          # 0.8x foveation scaling
          scale = 0.8;
          # 100 Mb/s
          bitrate = 100000000;
          encoders = [
            {
              encoder = "nvenc";
              codec = "h265";
              # 0.8 x 0.8 scaling
              width = 0.8;
              height = 0.8;
              offset_x = 0.0;
              offset_y = 0.0;
            }
          ];
          openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
        };
      };
    };
  };

  systemd.user.services.wayvr = {
    description = "WayVR desktop overlay for OpenXR/OpenVR";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wayvr}/bin/wayvr --replace";
      Restart = "on-failure";
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      5353
      9757
    ];
    allowedTCPPorts = [ 9757 ];
  };
}
