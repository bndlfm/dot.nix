{ pkgs, ... }:{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.tridactyl-native
      pkgs.gopass-jsonapi
      pkgs.plasma-browser-integration
    ];
    package = pkgs.firefox-devedition;
    #preferences = {
    #  "widget.use-xdg-desktop-portal.file-picker" = 1;
    #};
    profiles = {
      "oli3t15x.default-release" = {
        id = 0;
        name = "default-release";
        isDefault = false;
      };
      "oli3t15x.dev-edition-default" = {
        id = 1;
        name = "dev-edition-default";
        isDefault = true;
        settings = {};
        search = {
          force = true;
          default = "Google";
          order = [ "Google" "Perplexity" ];
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
                  { name = "channel"; value = "unstable"; }
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
          augmented-steam
          blocktube
          browserpass
          bypass-paywalls-clean
          clearurls
          copy-selection-as-markdown
          darkreader
          dearrow
          gopass-bridge
          return-youtube-dislikes
          sidebery
          simple-translate
          sponsorblock
          tampermonkey
          tridactyl
          ublacklist
          ublock-origin
          umatrix
          web-archives
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

