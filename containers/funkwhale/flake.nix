{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.funkwhale.url = "github:mmai/funkwhale-flake";

  outputs = { self, nixpkgs, funkwhale }:
    let
      system = "x86_64-linux";
    in
      {
        packages.${system} = {
          nixosConfigurations = {
            funkwhale-container = nixpkgs.lib.nixosSystem {
              modules = [
                funkwhale.nixosModules.default
                # typesense.nixosModules.default
                ( { pkgs, ... }:
                let 
                  hostname = "funkwhale";
                  secretFile = pkgs.writeText "djangoSecret" "test123";
                in {
                  boot.isContainer = true;

                  # Let 'nixos-version --json' know about the Git revision
                  # of this flake.
                  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
                  system.stateVersion = "23.05";

                  # Network configuration.
                  networking.useDHCP = false;
                  networking.firewall.allowedTCPPorts = [ 80 ];
                  networking.hostName = hostname;

                  nixpkgs.overlays = [ funkwhale.overlays.default ];

                  services.funkwhale = {
                    enable = true;
                    hostname = hostname;
                    defaultFromEmail = "noreply@funkwhale.rhumbs.fr";
                    protocol = "http"; # no ssl for virtualbox
                    forceSSL = false; # uncomment when LetsEncrypt needs to access "http:" in order to check domain
                    api = {
                        djangoSecretKeyFile = "${secretFile}";
                    };
                  };

                  # Overrides default 30M
                  services.nginx.clientMaxBodySize = "100m";

                  environment.systemPackages = with pkgs; [ ];
                })
              ];
            };
          };
        };
    };
}
