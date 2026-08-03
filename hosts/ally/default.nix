{
  config,
  pkgs,
  lib,
  ...
}:
let
  _g = import ../../lib/globals.nix { inherit config; }; # My global variables
  gameUser = "neko";
  mkDeckyPlugin =
    {
      name,
      pname,
      version,
      src,
      patches ? [ ],
      postPatch ? "",
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      mutableFiles ? [ ],
    }:
    {
      inherit name mutableFiles;
      package = pkgs.stdenvNoCC.mkDerivation {
        inherit
          pname
          version
          src
          patches
          postPatch
          nativeBuildInputs
          buildInputs
          ;

        installPhase = ''
          runHook preInstall
          mkdir -p "$out"
          cp -R . "$out/"
          runHook postInstall
        '';
      };
    };
  installDeckyPlugins =
    plugins:
    let
      managedPluginPatterns = lib.concatMapStringsSep "|" (plugin: lib.escapeShellArg plugin.name) plugins;
    in
    ''
      for candidate in "$pluginsDir"/*; do
        target=$(readlink "$candidate" 2>/dev/null || true)
        case "$target" in
          /nix/store/*)
            candidateName=$(basename "$candidate")
            case "$candidateName" in
              ${managedPluginPatterns}) ;;
              *) rm -f -- "$candidate" ;;
            esac
            ;;
        esac
      done

      ${lib.concatMapStringsSep "\n" (
        plugin:
        let
          pluginName = lib.escapeShellArg plugin.name;
        in
        ''
          (
            pluginName=${pluginName}
            pluginPath="$pluginsDir/$pluginName"
            backupPath="$backupDir/$pluginName.mutable"

            if [ -e "$pluginPath" ] && [ ! -L "$pluginPath" ]; then
              if [ -e "$backupPath" ]; then
                backupPath="$backupPath.$(date +%s)"
              fi
              mv "$pluginPath" "$backupPath"
            fi

            ln -sfn ${plugin.package} "$pluginPath"
            chown -h ${gameUser}:${gameUser} "$pluginPath"

            ${lib.concatMapStringsSep "\n" (
              file:
              let
                source = lib.escapeShellArg "${plugin.package}/${file.source}";
                target = lib.escapeShellArg "/home/${gameUser}/${file.target}";
                targetDir = lib.escapeShellArg "/home/${gameUser}/${builtins.dirOf file.target}";
              in
              ''
                install -d -m 0755 -o ${gameUser} -g ${gameUser} ${targetDir}
                install -m ${file.mode or "0644"} -o ${gameUser} -g ${gameUser} \
                  ${source} ${target}
              ''
            ) plugin.mutableFiles}
          )
        ''
      ) plugins}
    '';
  deckyLsfgVk = mkDeckyPlugin {
    name = "Decky LSFG-VK";
    pname = "decky-lsfg-vk";
    version = "0.12.5";
    src = pkgs.fetchzip {
      url = "https://github.com/xXJSONDeruloXx/decky-lsfg-vk/releases/download/v0.12.5/Decky.LSFG-VK.zip";
      hash = "sha256-gniQcjlY+fAM+3mTnfjrztBTZbi3UBAlKnHB6R582a0=";
    };
    postPatch = ''
      substituteInPlace py_modules/lsfg_vk/configuration.py \
        --replace-fail '"#!/bin/bash"' '"#!/usr/bin/env bash"'
    '';
  };
  simpleDeckyTdp = mkDeckyPlugin {
    name = "SimpleDeckyTDP";
    pname = "simple-decky-tdp";
    version = "1.0.5";
    src = pkgs.fetchzip {
      url = "https://github.com/aarron-lee/SimpleDeckyTDP/releases/download/v1.0.5/SimpleDeckyTDP.zip";
      hash = "sha256-0D02/F8XDCJi/hq+hlPp/d38n4kKPY68ODMCHdOpHAM=";
    };
  };
  allyCenter = mkDeckyPlugin {
    name = "Ally Center";
    pname = "ally-center";
    version = "1.2.0";
    src = pkgs.fetchzip {
      url = "https://github.com/PixelAddictUnlocked/allycenter/releases/download/v1.2.0/allycenter-v1.2.0.zip";
      hash = "sha256-tGQzKLj2YaFi13tF3V8nWJ1BTAk7t+pqqdwD231MamU=";
      stripRoot = false;
    };
    patches = [ ./ally-center-xbox-rgb.patch ];
    # SimpleDeckyTDP remains the sole TDP owner, so Ally Center starts with
    # its upstream external-TDP mode enabled.
    postPatch = ''
      substituteInPlace defaults/defaults.json \
        --replace-fail \
          '"charge_limit": 100' \
          '"charge_limit": 100, "use_external_tdp": true'
      substituteInPlace main.py \
        --replace-fail \
          '"charge_limit": 100' \
          '"charge_limit": 100, "use_external_tdp": True'
    '';
  };

  deckyLsfgVkRuntime = pkgs.runCommand "decky-lsfg-vk-runtime-0.12.5" {
    nativeBuildInputs = [
      pkgs.jq
      pkgs.unzip
    ];
  } ''
    unzip -q ${deckyLsfgVk.package}/bin/lsfg-vk_noui.zip -d "$out"
    jq --arg library "$out/lib/liblsfg-vk.so" \
      '.layer.library_path = $library' \
      "$out/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json" \
      > layer.json
    mv layer.json \
      "$out/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json"
  '';
  lsfgLauncher = pkgs.writeShellScript "lsfg" ''
    export LSFG_PROCESS=decky-lsfg-vk
    exec "$@"
  '';
in
{
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
    overlays = [ ];
  };
  # }}}

  # --- Systemd --- {{{
  systemd.tmpfiles.rules = [
    "f /home/${gameUser}/.steam/steam/.cef-enable-remote-debugging 0644 ${gameUser} ${gameUser} -"
  ];
  systemd.services.decky-loader = {
    aliases = [ "plugin_loader.service" ];
    environment.HOME = "/home/${gameUser}";
    preStart = lib.mkAfter ''
      pluginsDir="/home/${gameUser}/homebrew/plugins"
      backupDir="/home/${gameUser}/homebrew/plugin-backups"

      install -d -m 0755 -o ${gameUser} -g ${gameUser} \
        "$pluginsDir" "$backupDir"

      ${installDeckyPlugins [
        allyCenter
        deckyLsfgVk
        simpleDeckyTdp
      ]}

      install -d -m 0755 -o ${gameUser} -g ${gameUser} \
        "/home/${gameUser}/.local/lib" \
        "/home/${gameUser}/.local/share/vulkan/implicit_layer.d"
      install -m 0644 -o ${gameUser} -g ${gameUser} \
        ${deckyLsfgVkRuntime}/lib/liblsfg-vk.so \
        "/home/${gameUser}/.local/lib/liblsfg-vk.so"
      install -m 0644 -o ${gameUser} -g ${gameUser} \
        ${deckyLsfgVkRuntime}/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json \
        "/home/${gameUser}/.local/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json"

      if [ ! -e "/home/${gameUser}/lsfg" ]; then
        install -m 0755 -o ${gameUser} -g ${gameUser} \
          ${lsfgLauncher} "/home/${gameUser}/lsfg"
      fi
    '';
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
