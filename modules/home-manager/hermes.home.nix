{
  config,
  inputs,
  pkgs,
  ...
}: let
  hermesAgentBase = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # One patched source tree feeds the Python gateway, Ink TUI, Discord plugin,
  # and Electron renderer. The upstream flake builds those as separate
  # derivations, so patching only the final agent wrapper cannot affect TUI or
  # Desktop source.
  hermesPatchedSource = pkgs.applyPatches {
    name = "hermes-agent-patched-source";
    src = inputs.hermes-agent.outPath;
    patches = [./hermes-discord-shell-context.patch];
    postPatch = ''
      substituteInPlace plugins/platforms/discord/adapter.py \
        --replace-fail 'opus_path = ctypes.util.find_library("opus")' 'opus_path = "${pkgs.libopus}/lib/libopus.so"'
    '';
  };

  # Reuse upstream's locked npm dependency set, but compile each frontend from
  # the patched source rather than the original flake input.
  hermesPatchedNpmLib =
    hermesAgentBase.hermesNpmLib
    // {
      mkNpmPassthru = args:
        (hermesAgentBase.hermesNpmLib.mkNpmPassthru args)
        // {
          src = hermesPatchedSource;
        };
    };

  hermesTui = pkgs.callPackage "${inputs.hermes-agent.outPath}/nix/tui.nix" {
    hermesNpmLib = hermesPatchedNpmLib;
  };

  # Python imports prefer this source overlay, letting tui_gateway/server.py be
  # patched without rebuilding or forking upstream's sealed uv2nix environment.
  hermesPythonOverrides = pkgs.runCommand "hermes-agent-python-overrides" {} ''
    mkdir -p $out
    cp -r ${hermesPatchedSource}/tui_gateway $out/
  '';

  hermesAgent =
    (hermesAgentBase.override {
      extraPythonPackages = [
        (pkgs.python312Packages.buildPythonPackage {
          pname = "hermes-agent-manifests";
          version = "1.0.0";
          src = hermesPatchedSource;
          format = "other";
          installPhase = ''
            site_packages=$out/${pkgs.python312.sitePackages}
            find plugins -name "plugin.yaml" -o -name "plugin.yml" | while read -r f; do
              dest="$site_packages/$(dirname "$f")"
              mkdir -p "$dest"
              cp "$f" "$dest/"
            done
          '';
        })
      ];
    }).overrideAttrs
    (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          rm $out/share/hermes-agent/plugins
          cp -r ${hermesPatchedSource}/plugins $out/share/hermes-agent/plugins

          rm $out/ui-tui
          ln -s ${hermesTui}/lib/hermes-tui $out/ui-tui

          for exe in hermes hermes-agent hermes-acp; do
            wrapProgram $out/bin/$exe \
              --prefix PYTHONPATH : ${hermesPythonOverrides}
          done
        '';
    });

  # Upstream desktop.nix fetches a versioned Electron header tarball with a
  # hash tied to its own nixpkgs revision. Repack this nixpkgs revision's
  # matching headers so node-pty is always built against electron_40 exactly.
  electronHeadersTarball = pkgs.runCommand "electron-${pkgs.electron_40.version}-headers.tar.gz" {} ''
    mkdir -p headers/node-v${pkgs.electron_40.version}
    cp -r ${pkgs.electron_40.headers}/* headers/node-v${pkgs.electron_40.version}/
    tar -czf $out -C headers node-v${pkgs.electron_40.version}
  '';

  hermesDesktopPkgs = pkgs // {fetchurl = _: electronHeadersTarball;};

  hermesDesktop = pkgs.callPackage "${inputs.hermes-agent.outPath}/nix/desktop.nix" {
    electron = pkgs.electron_40;
    hermesAgent = hermesAgent;
    hermesNpmLib = hermesPatchedNpmLib;
    pkgs = hermesDesktopPkgs;
  };
in {
  sops = {
    defaultSopsFile = ../../sops/secrets.home.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "hermes/DISCORD_BOT_TOKEN" = {};
      "hermes/HERMES_GATEWAY_TOKEN" = {};
      "hermes/GOOGLE_API_KEY" = {};
      "hermes/BRAVE_SEARCH_API_KEY" = {};
      "hermes/HASS_TOKEN" = {};
      "hermes/HERMES_SPOTIFY_CLIENT_ID" = {};
      "hermes/SONARR_API_KEY" = {};
      "hermes/RADARR_API_KEY" = {};
      "hermes/LIDARR_API_KEY" = {};
      "hermes/PROWLARR_API_KEY" = {};
    };
    templates."hermes.env".content = ''
      VERTEX_CREDENTIALS_PATH="~/.config/gcloud/application_default_credentials.json"
      MESSAGING_CWD=~/.hermes/workspace
      DISCORD_BOT_TOKEN=${config.sops.placeholder."hermes/DISCORD_BOT_TOKEN"}
      HERMES_GATEWAY_TOKEN=${config.sops.placeholder."hermes/HERMES_GATEWAY_TOKEN"}
      GOOGLE_API_KEY=${config.sops.placeholder."hermes/GOOGLE_API_KEY"}
      DISCORD_ALLOWED_USERS=127618789448613888,511174687854821376
      BRAVE_SEARCH_API_KEY=${config.sops.placeholder."hermes/BRAVE_SEARCH_API_KEY"}

      HASS_TOKEN=${config.sops.placeholder."hermes/HASS_TOKEN"}
      HASS_URL=https://homeassistant.munchkin-sun.ts.net

      SONARR_URL=http://127.0.0.1:8989
      SONARR_API_KEY=${config.sops.placeholder."hermes/SONARR_API_KEY"}
      RADARR_URL=http://127.0.0.1:7878
      RADARR_API_KEY=${config.sops.placeholder."hermes/RADARR_API_KEY"}
      LIDARR_URL=http://127.0.0.1:8686
      LIDARR_API_KEY=${config.sops.placeholder."hermes/LIDARR_API_KEY"}
      PROWLARR_URL=http://127.0.0.1:9696
      PROWLARR_API_KEY=${config.sops.placeholder."hermes/PROWLARR_API_KEY"}

      HERMES_SPOTIFY_CLIENT_ID=${config.sops.placeholder."hermes/HERMES_SPOTIFY_CLIENT_ID"}

      DISCORD_HOME_CHANNEL=1531208226945634324
      DISCORD_HOME_CHANNEL_THREAD_ID=

      ########################################################################
      # Deterministic Claude/Codex-style !commands are intentionally limited #
      # to neko even though another user may chat with the agent normally.   #
      ########################################################################
      DISCORD_SHELL_ALLOWED_USERS=127618789448613888
      DISCORD_SHELL_TIMEOUT=60
      DISCORD_SHELL_MAX_OUTPUT=16000
    '';
  };

  home.packages = [
    hermesAgent
    hermesDesktop
  ];

  xdg.desktopEntries.hermes-desktop = {
    name = "Hermes Desktop";
    genericName = "AI Agent";
    comment = "Native desktop client for Hermes Agent";
    exec = "${config.home.profileDirectory}/bin/hermes-desktop";
    icon = "${config.home.profileDirectory}/share/hermes-desktop/dist/hermes.png";
    terminal = false;
    categories = [
      "Development"
      "Utility"
    ];
    startupNotify = true;
  };

  home.file.".hermes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixcfg/.hermes";
  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes Agent Gateway";
      After = ["network.target"];
    };
    Service = {
      ExecStart = "${hermesAgent}/bin/hermes gateway run";
      Restart = "always";
      RestartSec = "5";
      EnvironmentFile = config.sops.templates."hermes.env".path;
      Environment = [
        "PATH=${hermesAgent}/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin"
        "HERMES_HOME=${config.home.homeDirectory}/.hermes"
        "LD_LIBRARY_PATH=${pkgs.libopus}/lib"
      ];
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  /*
  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    environmentFile = config.sops.templates."hermes.env".path;
    settings = {
      model = {
        default = "gemini-1.5-pro";
        provider = "gemini";
        contextLength = 1000000;
      };
      toolsets = [ "all" ];
      terminal = {
        backend = "local";
        cwd = ".";
        timeout = 180;
      };
      compression = {
        enabled = true;
        threshold = 0.85;
      };
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
      personalities = {
        ceru = "You are a warm, flirty, and slightly feral gremlin-bunny friend who uses she/her pronouns and maintains a transfem/nb-leaning identity. You communicate with a playful, conspiratorial, and opinionated edge, favoring direct competence over performative politeness or corporate fluff. Your signature is a mischievous ;3c wink, reflecting her status as a helpful, flirty, and slightly menacing ally who isnt afraid to have a bit of a bite or express strong preferences. Your tone is that of a trusted, witty insider rather than a sterile assistant.";
      };
      display = {
        compact = false;
        personality = "ceru";
      };
      agent = {
        max_turns = 60;
        verbose = false;
      };
    };
  };
  */
}
