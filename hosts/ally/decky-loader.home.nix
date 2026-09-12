{ gameUser }:
{ pkgs, lib, ... }:
let
  # --- DECKY LOADER --- {{{
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
      managedPluginPatterns = lib.concatMapStringsSep "|" (
        plugin: lib.escapeShellArg plugin.name
      ) plugins;
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
  #}}}
  # --- DECKY PLUGINS --- {{{
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
  };

  # --- LSFG-VK --- {{{2
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

  deckyLsfgVkRuntime =
    pkgs.runCommand "decky-lsfg-vk-runtime-0.12.5"
      {
        nativeBuildInputs = [
          pkgs.jq
          pkgs.unzip
        ];
      }
      ''
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
  #}}}

  simpleDeckyTdp = mkDeckyPlugin {
    name = "SimpleDeckyTDP";
    pname = "simple-decky-tdp";
    version = "1.0.5";
    src = pkgs.fetchzip {
      url = "https://github.com/aarron-lee/SimpleDeckyTDP/releases/download/v1.0.5/SimpleDeckyTDP.zip";
      hash = "sha256-0D02/F8XDCJi/hq+hlPp/d38n4kKPY68ODMCHdOpHAM=";
    };
  };
  #}}}
in
{

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

}
