{ pkgs, config, home-manager }:{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.tridactyl-native
      pkgs.browserpass
      pkgs.plasma-browser-integration
    ];
    package = pkgs.firefox-devedition;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {};
        search = {
          force = true;
          default = "Perplexity";
          order = [ "Perplexity" "Google" ];
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "channel"; value = "${config.system.nixos.release}"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Perplexity" = {
              urls = [{ template = "https://www.perplexity.ai/search?q={searchTerms}"; }];
              iconUpdateURL = "https://www.perplexity.ai/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@perp" ];
            };
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "Bing".metaData.hidden = true;
          };
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          browserpass
          darkreader
          tridactyl
        ];
      };
    };
  };
}

# TODO: Read this and do something with it
# https://github.com/NixOS/nixpkgs/issues/171978
# Firefox needs to be convinced to use p11-kit-proxy by running a command like this:
#
# modutil -add p11-kit-proxy -libfile ${p11-kit}/lib/p11-kit-proxy.so -dbdir ~/.mozilla/firefox/*.default
# I was also able to accomplish the same by making use of extraPolciies when overriding the firefox package:
#
#         extraPolicies = {
#           SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
#         };

