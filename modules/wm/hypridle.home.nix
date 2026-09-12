{ pkgs, ... }: {
  # IDLE / LOCKSCREEN {{{
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.configFile."hypr/hypridle.conf" = {
    source = pkgs.writeText "hypridle.conf" ''
      general {
        lock_cmd = ${pkgs.hyprlock}/bin/hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = ${pkgs.hyprland}/bin/hyprctl dispatch 'dpms on'
      }

      listener {
        # Lock while the outputs are still rendering.  DPMS-off before
        # hyprlock can leave NVIDIA sessions with only the cursor visible.
        timeout = 300
        on-timeout = ${pkgs.hyprlock}/bin/hyprlock
      }

      listener {
        timeout = 330
        on-timeout = ${pkgs.hyprland}/bin/hyprctl dispatch 'dpms off'
        on-resume = ${pkgs.hyprland}/bin/hyprctl dispatch 'dpms on'
      }
    '';
    force = true;
  };

  xdg.configFile."hypr/hyprlock.conf" = {
    source = pkgs.writeText "hyprlock.conf" /* sh */ ''
      $font = Inconsolata Nerd Font

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
        monitor =
        blur_passes = 1
        blur_size = 7
        noise = 0.011700
        path = ~/Pictures/Iceland/adam-jang-MLKrf51NV8w-unsplash.jpg
      }

      input-field {
        monitor =
        size = 300, 60
        outline_thickness = 2
        inner_color = rgba(00000000)
        outer_color = rgba(99c0d0aa)
        check_color = rgba(99c0d0ff)
        fail_color = rgba(f38ba8ff)
        font_color = rgba(ffffffff)
        font_family = "Inconsolata Nerd Font"
        placeholder_text = "Password..."
        hide_input = true
        rounding = 8
        fade_on_empty = true
        position = 0, -20
        halign = center
        valign = center
      }

      label {
        monitor =
        text = "Hi, $USER"
        color = rgba(ffffffff)
        font_size = 32
        font_family = "Inconsolata Nerd Font"
        position = 0, -100
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:60000] hostname
        color = rgba(99c0d0ff)
        font_size = 18
        font_family = "Inconsolata Nerd Font"
        position = 0, 50
        halign = center
        valign = center
      }
    '';
    force = true;
  };
  #}}}
}
