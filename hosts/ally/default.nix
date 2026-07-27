{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  _g = import ../../lib/globals.nix { inherit config; }; # My global variables
in
{
  # --- Imports --- {{{
  imports = [
    # Main imports moved to flake.nix
  ];
  # }}}

  # --- Boot --- {{{
  boot = {
    kernelParams = [ "amd_pstate=active" ];
  };
  # }}}

  # --- Nix Settings --- {{{
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  # }}}

  # --- Nixpkgs --- {{{
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    overlays = [ ];
  };
  # }}}

  # --- System Packages --- {{{
  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];
  # }}}

  # --- Users --- {{{
  ##########################
  # Don't forget password! #
  ##########################
  users = {
    groups.neko = {
      name = "neko";
      gid = 10000;
    };
    users.neko = {
      isNormalUser = true;
      description = "neko";
      group = "neko";
      uid = 10000;
      home = "/home/neko";
      extraGroups = [
        "audio"
        "input"
        "media"
        "networkmanager"
        "wheel"
      ];
      linger = true;
    };
  };
  # }}}

  # --- Jovian (Steam UI) --- {{{
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "hyprland";
    };
    decky-loader = {
      enable = true;
    };
    hardware.has.amd.gpu = true;
  };
  # }}}

  # --- Services --- {{{
  services = {
    desktopManager = {
      plasma6.enable = true;
    };
    displayManager = {
      sddm.enable = true;
    };
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
  };
  # }}}

  # --- Networking --- {{{
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller
  networking = {
    hostName = "ally";
    networkmanager.enable = true; # Enable Networking
    firewall = {
      enable = true;
    };
  };
  # }}}

  # --- Audio --- {{{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };
  # }}}

  # --- TZ / i18n --- {{{
  # Set your time zone.
  time.timeZone = "America/Chicago";

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
  # }}}

  # --- State Version --- {{{
  system.stateVersion = "26.05";
  # }}}
}

# vim: foldmethod=marker foldmarker={{{,}}} foldlevel=1
