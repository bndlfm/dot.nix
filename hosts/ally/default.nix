{
  config,
  pkgs,
  lib,
  ...
}:
let
  _g = import ../../lib/globals.nix { inherit config; };
  gameUser = "neko";

  # Temporary powerbuttond test: suppress the Ally EC's post-resume KEY_POWER
  # event without changing the shared Steam Deck package.
  powerbuttondResumeDebounce = final: prev: {
    powerbuttond = prev.powerbuttond.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./powerbuttond.patch
      ];
    });
  };

in
{
  imports = [ (import ./decky-loader.home.nix { inherit gameUser; }) ];

  # --- Boot --- {{{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [
      "uinput"
      "hid_asus"
      "hid_asus_ally"
      "asus_wmi"
    ];
    kernelPackages = lib.mkOverride 10 (pkgs.linuxPackagesFor pkgs.linux-ogc);
    kernelParams = [ "amd_pstate=active" ];
  };
  # }}}

  # --- Hardware --- {{{
  hardware.uinput.enable = true;
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
        "neko"
      ];
    };
  };
  # }}}

  # --- Nixpkgs --- {{{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "pnpm-9.15.9"
      ];
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    overlays = [ powerbuttondResumeDebounce ];
  };
  # }}}

  # --- System Packages --- {{{
  environment.systemPackages = with pkgs; [
    chromium
    git
    home-manager
    p7zip
  ];
  # }}}

  # --- Users --- {{{
  ##########################
  # Don't forget password! #
  ##########################
  users = {
    groups.neko = {
      name = "${gameUser}";
      gid = 10000;
    };
    users.${gameUser} = {
      isNormalUser = true;
      description = "${gameUser}";
      group = "${gameUser}";
      uid = 1000;
      home = "/home/${gameUser}";
      extraGroups = [
        "audio"
        "input"
        "media"
        "networkmanager"
        "wheel"
      ];
    };
  };
  # }}}

  # --- Jovian (Steam UI) --- {{{
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "plasma";
      user = "neko";
    };
    decky-loader = {
      enable = true;
      user = gameUser;
      stateDir = "/home/${gameUser}/homebrew";
      extraPackages = [
        pkgs.python3
        pkgs.ryzenadj
        pkgs.systemd
      ];
      # Decky 3.2.6 passes a one-variable environment to subprocesses,
      # discarding PATH and making systemctl/python3 impossible to find.
      package = pkgs.decky-loader.overridePythonAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace backend/decky_loader/localplatform/localplatformlinux.py \
            --replace-fail \
              'env: ENV | None = {"LD_LIBRARY_PATH": ""}' \
              'env: ENV | None = None'
        '';
      });
    };
    hardware.has.amd.gpu = true;
  };
  # }}}

  # --- Secrets --- {{{
  sops.secrets."internet/TAILSCALE_AUTH_KEY" = {
    sopsFile = ../../sops/secrets.ally.yaml;
  };
  # }}}

  # --- Services --- {{{
  services = {
    fprintd = {
      enable = true;
    };
    inputplumber = {
      enable = true;
    };
    udev = {
      packages = [ pkgs.inputplumber ];
      extraRules = ''
        # ASUS ROG Xbox Ally Controller (Vendor: 0b05) hidraw uaccess permissions
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0b05", MODE="0660", TAG+="uaccess"
      '';
    };
    desktopManager = {
      plasma6.enable = true;
    };
    displayManager = {
      sddm.enable = true;
    };
    openssh = {
      enable = true;
      openFirewall = true;
    };
    tailscale = {
      authKeyFile = config.sops.secrets."internet/TAILSCALE_AUTH_KEY".path;
      extraUpFlags = [ "--operator=neko" ];
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
