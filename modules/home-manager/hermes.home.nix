{
  config,
  inputs,
  pkgs,
  ...
}:
let
  hermesAgent = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hermesDesktop = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop;
in
{
  sops = {
    defaultSopsFile = ../../sops/secrets.home.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "hermes/DISCORD_BOT_TOKEN" = { };
      "hermes/HERMES_GATEWAY_TOKEN" = { };
      "hermes/GOOGLE_API_KEY" = { };
      "hermes/BRAVE_SEARCH_API_KEY" = { };
      "hermes/HASS_TOKEN" = { };
      "hermes/HERMES_SPOTIFY_CLIENT_ID" = { };
      "hermes/SONARR_API_KEY" = { };
      "hermes/RADARR_API_KEY" = { };
      "hermes/LIDARR_API_KEY" = { };
      "hermes/PROWLARR_API_KEY" = { };
    };
    templates."hermes.env".content = ''
      VERTEX_CREDENTIALS_PATH="~/.config/gcloud/application_default_credentials.json"
      MESSAGING_CWD=~/.hermes/workspace
      DISCORD_BOT_TOKEN=${config.sops.placeholder."hermes/DISCORD_BOT_TOKEN"}
      HERMES_GATEWAY_TOKEN=${config.sops.placeholder."hermes/HERMES_GATEWAY_TOKEN"}
      GOOGLE_API_KEY=${config.sops.placeholder."hermes/GOOGLE_API_KEY"}
      DISCORD_ALLOWED_USERS=127618789448613888,511174687854821376
      BRAVE_SEARCH_API_KEY=${config.sops.placeholder."hermes/BRAVE_SEARCH_API_KEY"}
      PARCEL_17TRACK_API_TOKEN=${config.sops.placeholder."hermes/PARCEL_17TRACK_API_TOKEN"}

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

  home.packages = with pkgs; [
    hermesAgent
    hermesDesktop
    gws
    google-cloud-sdk
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

  home.file.".hermes".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixcfg/.hermes";

  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes Agent Gateway";
      After = [ "network.target" ];
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
      WantedBy = [ "default.target" ];
    };
  };
}
