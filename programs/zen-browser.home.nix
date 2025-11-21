{ pkgs, ... }:
{
  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
      kdePackages.plasma-browser-integration
      firefoxpwa
    ];
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
          default = "google";
          order = [ "google" ];
          engines = {
            ## SEARCH ENGINES
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "bing".metaData.hidden = true;

            ## NIX DOC SEARCH
            "home-manager-Options" = {
              urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }];
              icon = "https://home-manager-options.extranix.com/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@ho" ];
            };
            "nix-packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "nixos-options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "nixos-wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            ## MEDIA
            "youtube" = {
              urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
              icon = "https://www.youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@yt" ];
            };
          };
        };

        /* ---- EXTENSIONS ---- */
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          blocktube
          ##(pkgs.fetchFromGitea {
          ##  url = "https://gitflic.ru/project/magnolia1234/bpc_uploads.git";
          ##  ref = "main";
          ##  rev = "997898dccabb11f3c357a25c7696d4391e230a0e";
          ##})
          chatgptbox
          copy-selection-as-markdown
          darkreader
          dearrow
          duckduckgo-privacy-essentials
          firenvim
          furiganaize
          image-search-options
          pwas-for-firefox
          reddit-enhancement-suite
          return-youtube-dislikes
          sidebery
          sponsorblock
          tampermonkey
          tridactyl
          ublacklist
          ublock-origin
          umatrix
          web-archives
          yomitan
        ];
      };
    };
  };
}
