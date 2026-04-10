{ pkgs, ... }:
{
  services.synergy = {
    server = {
      enable = true;
      autoStart = true;
      configFile = pkgs.writeText "synergy.conf" ''
        section: screens
          meow:
          tablet:
          ally:
        end

        section: aliases
          ally:
            192.168.1.173
          meow:
            192.168.1.5
          tablet:
            192.168.1.60

        section: links
          ally:
            right = meow
          meow:
            left = ally
            right = tablet
          tablet:
            left = meow
        end

        section: options
          screenSaverSync = true
        end
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [ 24800 ];
}
