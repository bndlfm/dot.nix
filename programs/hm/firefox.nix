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
              definedAliases = [ "@p" ];
            };
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "Bing".metaData.hidden = true;
          };
        };

        /* ---- EXTENSIONS ---- */
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          blocktube
          bypass-paywalls-clean
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
          /*@import url(./hide_tabs_toolbar.css);*/

          /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/hide_tabs_toolbar.css made available under Mozilla Public License v. 2.0
          See the above repository for updates as well as full license text. */

          /* Note, if you have either native titlebar or menubar enabled, then you don't really need this style.
           * In those cases you can just use: #TabsToolbar{ visibility: collapse !important } */

          /* IMPORTANT:
           * Get window_control_placeholder_support.css
           * Window controls will be all wrong without it
           */

          :root[tabsintitlebar]{ --uc-toolbar-height: 40px; }
          :root[tabsintitlebar][uidensity="compact"]{ --uc-toolbar-height: 32px }

          #TabsToolbar{ visibility: collapse !important }

          :root[sizemode="fullscreen"] #TabsToolbar > :is(#window-controls,.titlebar-buttonbox-container){
            visibility: visible !important;
            z-index: 2;
          }

          :root:not([inFullscreen]) #nav-bar{
            margin-top: calc(0px - var(--uc-toolbar-height,0px));
          }

          :root[tabsintitlebar] #toolbar-menubar[autohide="true"]{
            min-height: unset !important;
            height: var(--uc-toolbar-height,0px) !important;
            position: relative;
          }

          #toolbar-menubar[autohide="false"]{
            margin-bottom: var(--uc-toolbar-height,0px)
          }

          :root[tabsintitlebar] #toolbar-menubar[autohide="true"] #main-menubar{
            -moz-box-flex: 1;
            -moz-box-align: stretch;
            background-color: var(--toolbar-bgcolor,--toolbar-non-lwt-bgcolor);
            background-clip: padding-box;
            border-right: 30px solid transparent;
            border-image: linear-gradient(to left, transparent, var(--toolbar-bgcolor,--toolbar-non-lwt-bgcolor) 30px) 20 / 30px
          }

          #toolbar-menubar:not([inactive]){ z-index: 2 }
          #toolbar-menubar[autohide="true"][inactive] > #menubar-items {
            opacity: 0;
            pointer-events: none;
            margin-left: var(--uc-window-drag-space-pre,0px)
          }

          /*@import url(./autohide_toolbox.css);*/
          /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_toolbox.css made available under Mozilla Public License v. 2.0
          See the above repository for updates as well as full license text. */

          /* Hide the whole toolbar area unless urlbar is focused or cursor is over the toolbar */
          /* Dimensions on non-Win10 OS probably needs to be adjusted */

          /* Compatibility options for hide_tabs_toolbar.css and tabs_on_bottom.css at the end of this file */

          :root{
            --uc-autohide-toolbox-delay: 200ms; /* Wait 0.1s before hiding toolbars */
            --uc-toolbox-rotation: 82deg;  /* This may need to be lower on mac - like 75 or so */
          }

          :root[sizemode="maximized"]{
            --uc-toolbox-rotation: 88.5deg;
          }

          /* Dummy variable to support versions 94-96, can be removed when 96 lands */
          :root{ --lwt-frame: var(--lwt-accent-color) }

          @media  (-moz-platform: windows),
                  (-moz-os-version: windows-win7),
                  (-moz-os-version: windows-win10){

            :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 8px !important; }

            @media screen and (min-resolution: 1.25dppx){
              :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 7px !important; }
            }
            @media screen and (min-resolution: 1.5dppx){
              :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 6px !important; }
            }
            @media screen and (min-resolution: 2dppx){
              :root[tabsintitlebar][sizemode="maximized"] #navigator-toolbox{ margin-top: -1px; }
            }
            #navigator-toolbox:not(:-moz-lwtheme){ background-color: -moz-dialog !important; }
          }

          :root[sizemode="fullscreen"],
          #navigator-toolbox[inFullscreen]{ margin-top: 0 !important; }

          #navigator-toolbox{
            position: fixed !important;
            display: block;
            background-color: var(--lwt-frame,black) !important;
            transition: transform 82ms linear, opacity 82ms linear !important;
            transition-delay: var(--uc-autohide-toolbox-delay) !important;
            transform-origin: top;
            transform: rotateX(var(--uc-toolbox-rotation));
            opacity: 0;
            line-height: 0;
            z-index: 1;
            pointer-events: none;
          }


          /* #mainPopupSet:hover ~ box > toolbox, */
          /* Uncomment the above line to make toolbar visible if some popup is hovered */
          #navigator-toolbox:hover,
          #navigator-toolbox:focus-within{
            transition-delay: 33ms !important;
            transform: rotateX(0);
            opacity: 1;
          }

          #navigator-toolbox > *{ line-height: normal; pointer-events: auto }

          #navigator-toolbox,
          #navigator-toolbox > *{
            width: 100vw;
            -moz-appearance: none !important;
          }

          /* These two exist for oneliner compatibility */
          #nav-bar{ width: var(--uc-navigationbar-width,100vw) }
          #TabsToolbar{ width: calc(100vw - var(--uc-navigationbar-width,0px)) }

          /* Don't apply transform before window has been fully created */
          :root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

          :root[customizing] #navigator-toolbox{
            position: relative !important;
            transform: none !important;
            opacity: 1 !important;
          }

          #navigator-toolbox[inFullscreen] > #PersonalToolbar,
          #PersonalToolbar[collapsed="true"]{ display: none }

          /* Uncomment this if tabs toolbar is hidden with hide_tabs_toolbar.css */
          /*#titlebar{ margin-bottom: -9px }*/

          /* Uncomment the following for compatibility with tabs_on_bottom.css - this isn't well tested though */
          /*
            :root{ --uc-titlebar-padding: 0px !important; }
            #navigator-toolbox{ flex-direction: column; display: flex; }
            #titlebar{ order: 2 }
            *
            @import url(./extraCSS/bookmarks_bar.css);

            #sidebar-header {
              display: none;
            }

            statuspanel[type="overLink"],
            #statuspanel[type="overLink"] {
              right: 0;
              display: inline;
            }
          */

          /*****************************************************
          *** HIDES SIDEBERY TO X PIXELS UNTIL HOVERED OVER ***
          *****************************************************/

          /*
          * Show sidebar only when the cursor is over it:
          * The border controlling sidebar width will be removed
          * so you'll need to modify these values to change width
          */

          #sidebar-box {
            --uc-sidebar-width: 34px;
            --uc-sidebar-hover-width: 210px;
            --uc-autohide-sidebar-delay: 100ms;
            /* Wait 0.6s before hiding sidebar */
            position: relative;
            min-width: var(--uc-sidebar-width) !important;
            width: var(--uc-sidebar-width) !important;
            max-width: var(--uc-sidebar-width) !important;
            z-index: 1;
          }

          #sidebar-box[positionend] {
            direction: rtl;
          }

          #sidebar-box[positionend] > * {
            direction: ltr;
          }

          #sidebar-box[positionend]:-moz-locale-dir(rtl) {
            direction: ltr;
          }

          #sidebar-box[positionend]:-moz-locale-dir(rtl) > * {
            direction: rtl;
          }

          #main-window[sizemode="fullscreen"] #sidebar-box {
            --uc-sidebar-width: 1px;
          }

          #sidebar-splitter {
            display: none;
          }

          #sidebar-header {
            display: note;
          }

          #sidebar-header {
            overflow: hidden;
            color: var(--chrome-color, inherit) !important;
            padding-inline: 0 !important;
          }

          #sidebar-header::before,
          #sidebar-header::after {
            content: "";
            display: flex;
            padding-left: 8px;
          }

          #sidebar-header,
          #sidebar {
            transition: min-width 115ms linear var(--uc-autohide-sidebar-delay) !important;
            min-width: var(--uc-sidebar-width) !important;
            will-change: min-width;
          }

          #sidebar-box:hover > #sidebar-header,
          #sidebar-box:hover > #sidebar {
            min-width: var(--uc-sidebar-hover-width) !important;
            transition-delay: 0ms !important;
          }

          .sidebar-panel {
            background-color: transparent !important;
            color: var(--newtab-text-primary-color) !important;
          }

          .sidebar-panel #search-box {
            -moz-appearance: none !important;
            background-color: rgba(249,249,250,0.1) !important;
            color: inherit !important;
          }

          /* Add sidebar divider and give it background */

          #sidebar,
          #sidebar-header {
            background-color: inherit !important;
            border-inline: 1px solid rgb(80,80,80);
            border-inline-width: 0px 1px;
          }

          #sidebar-box:not([positionend]) > :-moz-locale-dir(rtl),
          #sidebar-box[positionend] > * {
            border-inline-width: 1px 0px;
          }

          /* Move statuspanel to the other side when sidebar is hovered so it doesn't get covered by sidebar */

          #sidebar-box:not([positionend]):hover ~ #appcontent #statuspanel {
            inset-inline: auto 0px !important;
          }

          #sidebar-box:not([positionend]):hover ~ #appcontent #statuspanel-label {
            margin-inline: 0px !important;
            border-left-style: solid !important;
          }

          /*********************
          * BOOKMARK BAR FIX  *
          *********************/

          #PersonalToolbar {
            padding-left: 36px !important;
          }
        '';
      };
    };
  };
}

#extensionsettings = {
  #"*".installation_mode = "allowed";
  #### Sidebery
  #"{3c078156-979c-498b-8990-85f7987dd929}" = {
  #  install_url = "https://addons.mozilla.org/firefox/downloads/file/4246774/latest.xpi";
  #  installation_mode = "allowed";
  #};
  #### 10ten Japanese Reader
  #"{59812185-ea92-4cca-8ab7-cfcacee81281}" = {
  #  install_url = "https://addons.mozilla.org/firefox/downloads/file/4241410/latest.xpi";
  #  installation_mode = "allowed";
  #};
  ### tridactyl
  #{
  #  git = {}
  #}
#};

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



