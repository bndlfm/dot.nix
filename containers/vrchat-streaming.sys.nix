{ ... }:
{
  environment.etc."vrchat-streaming/compose.yaml".source = ./vrchat-streaming/compose.yaml;

  networking.firewall = {
    allowedTCPPorts = [
      8085
      8554
      8888
    ];
    allowedUDPPortRanges = [
      {
        from = 52000;
        to = 52100;
      }
    ];
  };
}
