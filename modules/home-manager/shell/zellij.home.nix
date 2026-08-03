{ ... }:
{
  home.file.".config/zellij/themes/kitty_nord.kdl".text = ''
    themes {
      kitty_nord {
        fg "#E5E9F0"
        bg "#2E3440"
        black "#2E3440"
        red "#BF616A"
        green "#A3BE8C"
        yellow "#EBCB8B"
        blue "#81A1C1"
        magenta "#B48EAD"
        cyan "#88C0D0"
        white "#E5E9F0"
        orange "#D08770"
      }
    }
  '';

  programs.zellij = {
    enable = true;
    enableFishIntegration = false;

    # Keep behavior close to your Kitty setup.
    settings = {
      default_shell = "fish";
      copy_command = "wl-copy";
      copy_on_select = true;
      mouse_mode = true;
      pane_frames = true;
      theme = "kitty_nord";
    };

    extraConfig = ''
      keybinds {
          normal {
              bind "Alt h" "Alt Left"  { MoveFocusOrTab "Left"; }
              bind "Alt n" "Alt Down"  { MoveFocusOrTab "Down"; }
              bind "Alt e" "Alt Up"    { MoveFocusOrTab "Up"; }
              bind "Alt i" "Alt Right" { MoveFocusOrTab "Right"; }

              bind "Alt b" { NewPane "Down"; }
              bind "Alt o" { NewPane "Right"; }

              bind "Alt t" { NewTab; }
              bind "Alt q" { CloseTab; }
              bind "Alt ." { GoToNextTab; }
              bind "Alt ," { GoToPreviousTab; }
          }
      }
    '';
  };
}
