{ pkgs, ... }: {
  # IDLE / LOCKSCREEN {{{
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.configFile."hypr/hypridle.conf" = {
    source = pkgs.writeText "hypridle.conf" ''
      general {
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock"
        before_sleep_cmd = "loginctl lock-session"
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch 'dpms on'"
      }

      listener {
        timeout = 300
        on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch 'dpms off'"
        on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch 'dpms on'"
      }

      listener {
        timeout = 600
        on-timeout = "${pkgs.hyprlock}/bin/hyprlock"
      }
    '';
    force = true;
  };

  xdg.configFile."hypr/hyprlock.conf" = {
    source = pkgs.writeText "hyprlock.conf" /* sh */ ''
      $font = Monospace

      general {
        hide_cursor = false
      }

      animations {
        enabled = true
        bezier = linear, 1, 1, 0, 0
        animation = fadeIn, 1, 2, linear
        animation = fadeOut, 1, 2, linear
      }

      background {
        monitor = ""
        color = rgba(25, 20, 20, 1)
      }

      input-field {
        monitor = ""
        size = 300, 60
        outline_thickness = 2
        inner_color = rgba(00000000)
        outer_color = rgba(99c0d0aa)
        check_color = rgba(99c0d0ff)
        fail_color = rgba(f38ba8ff)
        font_color = rgba(ffffffff)
        placeholder_text = "Password..."
        hide_input = true
        rounding = 8
        fade_on_empty = true
        position = 0, -20
        halign = center
        valign = center
      }

      label {
        monitor = ""
        text = "Hi, $USER"
        color = rgba(ffffffff)
        font_size = 32
        font_family = $font
        position = 0, -100
        halign = center
        valign = center
      }

      label {
        monitor = ""
        text = "$HOST - $TIME"
        color = rgba(99c0d0ff)
        font_size = 18
        font_family = $font
        position = 0, 50
        halign = center
        valign = center
      }
    '';
    force = true;
  };
  #}}}
}
