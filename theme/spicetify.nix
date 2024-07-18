{ spicetify-nix, ... }:{
  programs.spicetify =
    let
      system = "x86_64-linux";
      spicePkgs = spicetify-nix.packages.${system}.default;
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
      theme = spicePkgs.themes.catpuccin;
      colorScheme = "mocha";
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
    };
}
#{
#  nixpkgs,
#  spicetify-nix,
#  ...
#}:
#
#let
#  system = "x86_64-linux";
#  pkgs = nixpkgs.legacyPackages.${system};
#  spicePkgs = spicetify-nix.packages.${system}.default;
#in {
#
#  programs = {
#    spicetify =
#      let
#        # use a different version of spicetify-themes than the one provided by
#        # spicetify-nix
#        officialThemesOLD = pkgs.fetchgit {
#          url = "https://github.com/spicetify/spicetify-themes";
#          rev = "c2751b48ff9693867193fe65695a585e3c2e2133";
#          sha256 = "0rbqaxvyfz2vvv3iqik5rpsa3aics5a7232167rmyvv54m475agk";
#        };
#        # pin a certain version of the localFiles custom app
#        localFilesSrc = pkgs.fetchgit {
#          url = "https://github.com/hroland/spicetify-show-local-files/";
#          rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
#          sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
#        };
#      in {
#
#      enable = true;
#
#      theme = {
#        name = "Flow";
#        src = officialThemesOLD;
#        requiredExtensions = [
#          # define extensions that will be installed with this theme
#          {
#            # extension is "${src}/Dribbblish/dribbblish.js"
#            filename = "user.css";
#            src = "${officialThemesOLD}/Flow";
#          }
#        ];
#        appendName = true; # theme is located at "${src}/Dribbblish" not just "${src}"
#
#        # changes to make to config-xpui.ini for this theme:
#        patches = {
#          "xpui.js_find_8008" = ",(\\w+=)32,";
#          "xpui.js_repl_8008" = ",$\{1}56,";
#        };
#        injectCss = true;
#        replaceColors = true;
#        overwriteAssets = true;
#        sidebarConfig = true;
#      };
#
#      # specify that we want to use our custom colorscheme
#      colorScheme = "Flow";
#
#      enabledCustomApps = with spicePkgs.apps; [
#        new-releases
#        {
#          name = "localFiles";
#          src = localFilesSrc;
#          appendName = false;
#        }
#        marketplace
#      ];
#      enabledExtensions = with spicePkgs.extensions; [
#        playlistIcons
#        lastfm
#          #genre
#        historyShortcut
#        hidePodcasts
#        fullAppDisplay
#        shuffle
#      ];
#    };
#  };
#}
