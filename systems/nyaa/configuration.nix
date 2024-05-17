# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

<<<<<<< HEAD
      ../../containers/pihole/pihole.nix
      ../../containers/retroarch-web.nix
      ../../containers/grimoire/grimoire.nix
=======
      ../../containers/pihole.nix
      ../../containers/grimoire/grimoire.nix
      ../../containers/home-assistant.nix
>>>>>>> 6c2b2f897c8dee9ff97ba34dc777967bddf09eb5

      ../../modules/tailscale.nix
    ];

  environment.systemPackages = with pkgs; [
    arion
    docker-client
    gcc
    git
    #home-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # NOTE: SERVICES:
  services = {
    fail2ban.enable = true;
    ollama.enable = true;
    openssh.enable = true;
    tailscale = {
      enable = true;
    };
    xserver = {
      layout = "us";
      xkbVariant = "";
    };
  };

  networking = {
    hostName = "nyaa";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        53    #PIHOLE
        5173  #GRIMOIRE
        41641 #TAILSCALE
      ];
      allowedUDPPorts = [
        53    #PIHOLE
        5173  #GRIMOIRE
        41641 #TAILSCALE
      ];
    };
    networkmanager.enable = true;
  };

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dnsname_enabled = true;
    };
  };

  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.latest;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.server = {
    isNormalUser = true;
    description = "server";
    extraGroups = [ "podman" "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
