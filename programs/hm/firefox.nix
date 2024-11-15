{ pkgs, ... }:
let
in {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
      gopass-jsonapi
      plasma-browser-integration
      firefoxpwa
    ];
    package = pkgs.firefox-devedition;
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
          order = [ "Google" ];
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
            "Home-manager Options" = {
              urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }];
              iconUpdateURL = "https://home-manager-options.extranix.com/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@ho" ];
            };
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "Bing".metaData.hidden = true;
          };
        };

        /* ---- EXTENSIONS ---- */
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          blocktube
          #          bypass-paywalls-clean
          chatgptbox
          clearurls
          copy-selection-as-markdown
          darkreader
          dearrow
          furiganaize
          gopass-bridge
          image-search-options
          localcdn
          lovely-forks
          pwas-for-firefox
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
          yomitan
        ];

        /* ---- userChrome ---- */
        userChrome = /* css */ ''
          /* NOTE: Hide tabs bar b/c of sideberry */
              #TabsToolbar{ visibility: collapse !important }

          /* NOTE: Hide side bar header for sidebery */
             #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"] #sidebar-header {
               visibility: collapse;
             }

          /* NOTE: Hides the main toolbar and shows it when the cursor is over the tabs toolbar as well as whenever the focus is inside nav-bar, such as when urlbar is focused. */
          /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_main_toolbar.css */
          /* See the above repository for updates as well as full license text. */
              :root{
                --uc-navbar-transform: -40px;
                --uc-autohide-toolbar-delay: 1.8s;
                --uc-autohide-toolbar-duration: 400ms;
              }
              :root[uidensity="compact"]{ --uc-navbar-transform: -34px }

              #navigator-toolbox > div{ display: contents; }
              :root[sessionrestored] :where(#nav-bar,#PersonalToolbar,#tab-notification-deck,.global-notificationbox){
                transform: translateY(var(--uc-navbar-transform))
              }
              :root:is([customizing],[chromehidden*="toolbar"]) :where(#nav-bar,#PersonalToolbar,#tab-notification-deck,.global-notificationbox){
                transform: none !important;
                opacity: 1 !important;
              }

              #nav-bar:not([customizing]){
                opacity: 0;
                transition:  transform var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay), opacity var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay) !important;
                position: relative;
                z-index: 2;
              }
              #titlebar{ position: relative; z-index: 3 }

              #navigator-toolbox,
              #sidebar-box,
              #sidebar-main,
              #sidebar-splitter,
              #tabbrowser-tabbox{
                z-index: auto !important;
              }

              /* Show when toolbox is focused, like when urlbar has received focus */
              #navigator-toolbox:focus-within > .browser-toolbar{
                transform: translateY(0);
                opacity: 1;
                transition-duration: var(--uc-autohide-toolbar-duration), var(--uc-autohide-toolbar-duration) !important;
                transition-delay: 0s !important;
              }

              /* Show when toolbox is hovered */
              #titlebar:hover ~ .browser-toolbar,
              .browser-titlebar:hover ~ :is(#nav-bar,#PersonalToolbar),
              #nav-bar:hover,
              #nav-bar:hover + #PersonalToolbar{
                transform: translateY(0);
                opacity: 1;
                transition-duration: var(--uc-autohide-toolbar-duration), var(--uc-autohide-toolbar-duration) !important;
                transition-delay: 0s !important;
              }
              :root[sessionrestored] #urlbar[popover]{
                opacity: 0;
                pointer-events: none;
                transition: transform var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay), opacity var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay);
                transform: translateY(var(--uc-navbar-transform));
              }
              #mainPopupSet:has(> [role="group"][panelopen]) ~ toolbox #urlbar[popover],
              .browser-titlebar:is(:hover,:focus-within) ~ #nav-bar #urlbar[popover],
              #nav-bar:is(:hover,:focus-within) #urlbar[popover],
              #urlbar-container > #urlbar[popover]:is([focused],[open]){
                opacity: 1;
                pointer-events: auto;
                transition-delay: 0ms;
                transform: translateY(0);
              }
              #urlbar-container > #urlbar[popover]:is([focused],[open]){
               transition-duration: 100ms; /* Faster when focused */
              }
              /* This ruleset is separate, because not having :has support breaks other selectors as well */
              #mainPopupSet:has(> [role="group"][panelopen]) ~ #navigator-toolbox > .browser-toolbar{
                transition-delay: 33ms !important;
                transform: translateY(0);
                opacity: 1;
              }
              /* If tabs are in sidebar then nav-bar doesn't normally have its own background - so we nee to add it back */
              #nav-bar.browser-titlebar{
                background: inherit;
              }
              #toolbar-menubar:not([autohide="true"]) ~ #nav-bar.browser-titlebar{
                background-position-y: -28px; /* best guess, could vary */
                border-top: none !important;
              }

              /* Bookmarks toolbar needs so extra rules */
              #PersonalToolbar{ transition: transform var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay) !important; position: relative; z-index: 1 }

              /* Move up the content view */
              :root[sessionrestored]:not([inFullscreen],[chromehidden~="toolbar"]) > body > #browser{ margin-top: var(--uc-navbar-transform); }

          /* NOTE: Show sidebar only when the cursor is over it.

              /* The border controlling sidebar width will be removed so you'll need to modify these      */
              /* values to change width, made available under Mozilla Public License v. 2.0               */
              /* https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_sidebar.css   */
              #sidebar-box{
                --uc-sidebar-width: 40px;
                --uc-sidebar-hover-width: 210px;
                --uc-autohide-sidebar-delay: 600ms; /* Wait 0.6s before hiding sidebar */
                --uc-autohide-transition-duration: 115ms;
                --uc-autohide-transition-type: linear;
                --browser-area-z-index-sidebar: 3;
                position: relative;
                min-width: var(--uc-sidebar-width) !important;
                width: var(--uc-sidebar-width) !important;
                max-width: var(--uc-sidebar-width) !important;
                z-index: var(--browser-area-z-index-sidebar,3);
              }
              #sidebar-box[positionend]{ direction: rtl }
              #sidebar-box[positionend] > *{ direction: ltr }

              #sidebar-box[positionend]:-moz-locale-dir(rtl){ direction: ltr }
              #sidebar-box[positionend]:-moz-locale-dir(rtl) > *{ direction: rtl }

              #main-window[sizemode="fullscreen"] #sidebar-box{ --uc-sidebar-width: 1px; }

              #sidebar-splitter{ display: none }

              #sidebar-header{
                overflow: hidden;
                color: var(--chrome-color, inherit) !important;
                padding-inline: 0 !important;
              }

              #sidebar-header::before,
              #sidebar-header::after{
                content: "";
                display: flex;
                padding-left: 8px;
              }

              #sidebar-header,
              #sidebar{
                transition: min-width var(--uc-autohide-transition-duration) var(--uc-autohide-transition-type) var(--uc-autohide-sidebar-delay) !important;
                min-width: var(--uc-sidebar-width) !important;
                will-change: min-width;
              }
              #sidebar-box:hover > #sidebar-header,
              #sidebar-box:hover > #sidebar{
                min-width: var(--uc-sidebar-hover-width) !important;
                transition-delay: 0ms !important;
              }

              .sidebar-panel{
                background-color: transparent !important;
                color: var(--newtab-text-primary-color) !important;
              }

              .sidebar-panel #search-box{
                -moz-appearance: none !important;
                background-color: rgba(249,249,250,0.1) !important; 
                color: inherit !important;
              }

              /* Add sidebar divider and give it background */
              #sidebar,
              #sidebar-header{
                background-color: inherit !important;
                border-inline: 1px solid rgb(80,80,80);
                border-inline-width: 0px 1px;
              }

              #sidebar-box:not([positionend]) > :-moz-locale-dir(rtl),
              #sidebar-box[positionend] > *{
                border-inline-width: 1px 0px;
              }

              /* Move statuspanel to the other side when sidebar is hovered so it doesn't get covered by sidebar */
              #sidebar-box:not([positionend]):hover ~ #appcontent #statuspanel{
                inset-inline: auto 0px !important;
              }
              #sidebar-box:not([positionend]):hover ~ #appcontent #statuspanel-label{
                margin-inline: 0px !important;
                border-left-style: solid !important;
              }
        '';
      };
    };
  };
}
