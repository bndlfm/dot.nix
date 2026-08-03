{ pkgs, ... }:
{
  ########## XSESSION - BSPWM ##########
  xsession.windowManager.bspwm = {
    enable = true;
    alwaysResetDesktops = true;
    monitors = {
      HDMI-0 = [ "1" "2" "3" "4" ];
      DP-0 = [ "5" "6" "7" "8" ];
      DP-3 = [ "9" "0" ];
    };
    settings = {
      border_width = 6;
      window_gap = 12;
      split_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = true;
    };
    rules = {
      "*:*:'Picture-in-Picture'" = { floating = true; focus = false; };
      "steam" = { floating = true; };
      "steam_app" = { floating = true; };
      "Steam" = { floating = true; };
      "mpv" = { floating = true; };
      "synergy" = { floating = true; };
      "blueman-applet" = { floating = true; };
    };
    startupPrograms = [
      "nvidia-settings --assign CurrentMetaMode=\"HDMI-0: nvidia-auto-select +0+0 {rotation=right}, DP-0: nvidia-auto-select +1080+0, DP-3: nvidia-auto-select +3640+0 {rotation=right}\""
      "sxhkd"
      "~/.config/polybar/polybar.sh"
      "dunst"
      "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse ~/Documents/GoogleDrive"
      "xset r rate 325 70"
      "xset m 0 0"
      "nitrogen --restore"
      "xsetroot -xcf ${pkgs.volantes-cursors}/share/icons/volantes_light_cursors/cursors/left_ptr 32"
      "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd"
      "kdeconnect-indicator"
    ];
  };
  services.sxhkd = {
    enable = true;
    keybindings = {
      ##############################
      #   WM INDEPENDENT HOTKEYS   #
      ##############################
      "mod4 + BackSpace" = "kitty";
      "mod4 + @space" = "rofi -combi-modi window,drun,run,ssh -show combi -modi combi -show-icons # -theme ~/.config/rofi/themes/base16-rofi/base16-nord.rasi";
      "mod4 + shift + @space" = "~/.config/rofi/scripts/splatmoji/splatmoji type";

      # terminal dropdown
      "mod4 + grave" = "tdrop -mat -w -5 -y 30 kitty";

      # make sxhkd reload its configuration files:
      "mod4 + Escape" = "pkill -USR1 -x sxhkd && notify-send 'Configuration Reloaded'";

      # deadd notification center popup
      "mod4 + slash" = "kill -s USR1 $(pidof deadd-notification-center)";

      # toggle picom
      "mod4 + z" = "killorrun picom --config ~/.config/picom/picom.conf";

      # screen capture
      "Print" = "~/.nix-profile/bin/scrotshot.sh select";
      "mod4 + Print" = "~/.nix-profile/bin/scrotshot.sh freeze";
      "Control + Print" = "~/.nix-profile/bin/scrotshot.sh select";
      "Shift + Print" = "~/.nix-profile/bin/scrotshot.sh focused";

      #####################
      #   BSPWM HOTKEYS   #
      #####################

      # Quit/Restart BSPWM
      "mod4 + alt + {q,r}" = "bspc {quit,wm -r}";

      # Close and Kill
      "mod4 + {_,shift + }q" = "bspc node -{c,k}";

      # Alternate Between the Tiled and Monocle Layout
      "mod4 + m" = "bspc desktop -l next";

      # Send the Newest Marked Node to the Newest Preselected Node
      "mod4 + y" = "bspc node newest.marked.local -n newest.!automatic.local";

      # Swap the Current Node and the Biggest Node
      "mod4 + g" = "bspc node -s biggest";

      #-------------------#
      #    State/Flags    #
      #-------------------#

      # Set the Window State
      "mod4 + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";

      # Set the Node Flags
      "mod4 + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";

      #-------------------#
      #    Focus/Swap     #
      #-------------------#

      # Focus the Node in the Given Direction
      "mod4 + {_,shift + }{h,n,e,i}" = "bspc node -{f,s} {west,south,north,east}";

      # Focus the Next/Previous Node in the Current Desktop
      "mod4 + {_,shift + }c" = "bspc node -f {next,prev}.local";

      # Focus the Next/Previous Desktop in the Current Monitor
      "mod4 + {comma,period}" = "bspc desktop -f {prev,next}.local";

      # Focus the Last Node/Desktop
      "mod4 + {shift + grave,Tab}" = "bspc {node,desktop} -f last";

      # Focus or Send to the Given Desktop
      "mod4 + {_,shift + }{1-9}" = "bspc {desktop -f,node -d} '^{1-9}'";

      #-------------------#
      #    Preselect      #
      #-------------------#

      # Preselect the Direction
      "mod4 + alt + {h, n, e, i}" = "bspc node -p {west,south,north,east}";

      # Preselect the Ratio
      "mod4 + alt + {1-9}" = "bspc node -o 0.{1-9}";

      # Cancel the Preselection for the Focused Node
      "mod4 + alt + space" = "bspc node -p cancel";

      # Cancel the Preselection for the Focused Desktop
      "mod4 + alt + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

      #-------------------#
      #    Move/Resize    #
      #-------------------#

      # Expand a Window by Moving One of Its Sides Outward
      "mod4 + ctrl + {h, n, e, i}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

      # Contract a Window by Moving One of Its Sides Inward
      "mod4 + ctrl + shift + {h, n, e, i}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

      # Move a Floating Window
      "mod4 + shift + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";

      #---------------------------#
      #   Rotate/Flip Desktops    #
      #---------------------------#

      # Rotate a Desktop
      "mod4 + {_, shift +}r" = "bspc node@/ --rotate {90,-90}";
      };
    };
  #home.packages = with pkgs; [
  #  (writeShellScriptBin "scrotshot.sh" /* sh */ ''
  #    #!/bin/bash

  #    # Function to capture screenshot and copy to clipboard
  #    capture_screenshot() {
  #      scrot "$@" --exec 'xclip -selection clipboard -t image/png -i < $f && notify-send "Screenshot Captured"'
  #    }

  #    # Check the command-line argument and execute the corresponding scrot command
  #    case "$1" in
  #      "full")
  #          capture_screenshot ~/%b%d::%H%M%S.png --multidisp --quality 75
  #          ;;
  #      "freeze")
  #          capture_screenshot ~/%b%d::%H%M%S.png --freeze --quality 75
  #          ;;
  #      "select")
  #          capture_screenshot --select --freeze --quality 75 ~/%b%d::%H%M%S.png
  #          ;;
  #      "focused")
  #          capture_screenshot ~/%b%d::%H%M%S.png --focused --border --delay 5 --count --quality 75

  #      *)
  #          echo "Usage: $0 [full|freeze|select|focused]"
  #          exit 1
  #          ;;
  #    esac
  #  '')
  #];
}
