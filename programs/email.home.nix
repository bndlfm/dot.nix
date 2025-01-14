{ config, pkgs, ... }:

{
  accounts.email.accounts =
    {
      fflb = {
        primary = true;
        address = "firefliesandlightningbugs@gmail.com";
        aliases = [ "fflb@gmail.com" ];
        realName = "Benji";
        userName = "firefliesandlightningbugs@gmail.com";

        gpg = {
          key = "4986B9E3";
        };

        imap = {
          host = "imap.gmail.com";
          port = 993;
        };
        smtp = {
          host = "smtp.gmail.com";
          port = 465;
        };

        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          extraConfig = {
            channel = {
              CopyArrivalDate = "yes";
            };
          };
        };
        neomutt = {
          enable = true;
        };
        passwordCommand = "cat ${config.sops.secrets.GMAIL_APP_PASS.path}";
      };
    };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  programs.neomutt = {
    enable = true;
    # Colemak bindings
    binds = [
      { action = "next-entry"; key = "n"; map = [ "index" ]; } # Was "index"
      { action = "half-down"; key = "\\Cn"; map = [ "index" ]; }  # Was "index"
      { action = "previous-entry"; key = "e"; map = [ "index" ]; } # Was "index"
      { action = "half-up"; key = "\\Ce"; map = [ "index" ]; }   # Was "index"
      { action = "search-next"; key = "k"; map = [ "index" ]; }  # Was "index"
      { action = "edit"; key = "E"; map = [ "index" ]; }       # Was "index"

      { action = "next-line"; key = "n"; map = [ "pager" ]; }      # Was "pager"
      { action = "next-entry"; key = "N"; map = [ "pager" ]; }     # Was "pager"
      { action = "half-down"; key = "\\Ce"; map = [ "pager" ]; }   # Was "pager"
      { action = "previous-line"; key = "e"; map = [ "pager" ]; }   # Was "pager"
      { action = "previous-entry"; key = "E"; map = [ "pager" ]; }  # Was "pager"
      { action = "half-up"; key = "\\Ce"; map = [ "pager" ]; }     # Was "pager"
      { action = "search-next"; key = "k"; map = [ "pager" ]; }    # Was "pager"
    ];
    macros = [
      { action = "<shell-escape>mbsync fflb<enter>"; key = "%"; map = [ "index" ]; } # Was "index"

      { action = "<pipe-message>urlscan<enter>"; key = "\\Cu"; map = [ "index" ]; } # Was "index"
      { action = "<pipe-message>urlscan<enter>"; key = "\\Cu"; map = [ "pager" ]; } # Was "pager"

      { action = "<save-message>=Archive<enter>"; key = "y"; map = [ "index" ]; } # Was "index"
      { action = "<save-message>=Archive<enter>"; key = "y"; map = [ "pager" ]; } # Was "pager"

      { action = "<change-folder>=Archive<enter>"; key = "ta"; map = [ "index" ]; } # Was "index"
      { action = "<change-folder>=INBOX<enter>"; key = "ti"; map = [ "index" ]; } # Was "index"
      { action = "<change-folder>=Trash<enter>"; key = "tt"; map = [ "index" ]; } # Was "index"
      { action = "<change-folder>=Sent<enter>"; key = "ts"; map = [ "index" ]; } # Was "index"
      { action = "<change-folder>=Drafts<enter>"; key = "td"; map = [ "index" ]; } # Was "index"
    ];
    extraConfig = ''
      set attribution="%n wrote:"
      set confirmappend="no"
      set date_format="%F at %R %Z"
      set edit_headers="yes"
      set fast_reply="yes"
      set include="yes"
      set index_format="%Z %[%F] %-30.30n | %s"
      set mail_check="0"
      set mark_old="no"
      set markers="no"
      set menu_scroll="yes"
      set pager_context="3"
      set pager_index_lines="10"
      set pager_stop="yes"
      set record="+INBOX"
      set sleep_time="0"
      set sort_aux="reverse-last-date-received"
      set timeout="0"
      set wait_key="no"

      # See http://www.mutt.org/doc/manual/#color

      # Patch syntax highlighting
      #color   normal  white           default
      color   body    brightwhite     default         ^[[:space:]].*
      color   body    yellow          default         ^(diff).*
      #color   body    white           default         ^[\-\-\-].*
      #color   body    white           default         ^[\+\+\+].*
      #color   body    green           default         ^[\+].*
      #color   body    red             default         ^[\-].*
      #color   body    brightblue      default         [@@].*
      color   body    brightwhite     default         ^(\s).*
      color   body    cyan            default         ^(Signed-off-by).*
      color   body    cyan            default         ^(Docker-DCO-1.1-Signed-off-by).*
      color   body    brightwhite     default         ^(Cc)
      color   body    yellow          default         "^diff \-.*"
      color   body    brightwhite     default         "^index [a-f0-9].*"
      color   body    brightblue      default         "^---$"
      color   body    white           default         "^\-\-\- .*"
      color   body    white           default         "^[\+]{3} .*"
      color   body    green           default         "^[\+][^\+]+.*"
      color   body    red             default         "^\-[^\-]+.*"
      color   body    brightblue      default         "^@@ .*"
      color   body    green           default         "LGTM"
      color   body    brightmagenta   default         "-- Commit Summary --"
      color   body    brightmagenta   default         "-- File Changes --"
      color   body    brightmagenta   default         "-- Patch Links --"
      color   body    green           default         "^Merged #.*"
      color   body    red             default         "^Closed #.*"
      color   body    brightblue      default         "^Reply to this email.*"
    '';
  };

  services.mbsync = {
    enable = true;
    frequency = "*:0/15";
  };
}
