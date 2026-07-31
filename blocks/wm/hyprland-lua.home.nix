{
  config,
  pkgs,
  ...
}:
let
  _g = import ../../lib/globals.nix { inherit config; };
  hyprScrolling = true;
in
{
  # ── NOTE ─────────────────────────────────────────────────────────────────────
  # Hyprland 0.55 deprecated hyprlang in favour of Lua. Home Manager's `settings`
  # key still exists but generates broken Lua for some keywords (e.g. exec-once
  # becomes `hl.exec-once` which is invalid). Until HM's native Lua support lands,
  # put the full config in `extraConfig` as raw Lua, using Nix interpolation for
  # variables that come from globals.nix or the Nix let-bindings above.
  # ─────────────────────────────────────────────────────────────────────────────

  # {{{ Imports & Packages
  imports = [
    ./waybar.home.nix
  ];

  home.packages = with pkgs; [
    hdrop
    hyprpaper
    hyprshot
    hypridle
    hyprlock
    swaynotificationcenter
    wayland-utils
    waypaper
  ];
  # }}}

  # {{{ Hyprland Window Manager
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";

    extraConfig = /* lua */ ''
      local mainMod     = "SUPER"
      local useScrolling = ${if hyprScrolling then "true" else "false"} --- DONT SET MANUALLY

      --- Monitors --- {{{
      --- https://wiki.hypr.land/Configuring/Basics/Monitors/
      hl.monitor({
        output    = "${_g.monitors.left.output}",
        mode      = "${toString _g.monitors.left.res.width}x${toString _g.monitors.left.res.height}",
        position  = "${toString _g.monitors.left.pos.x}x${toString _g.monitors.left.pos.y}",
        scale     = 1,
        transform = 3,
      })

      hl.monitor({
        output   = "${_g.monitors.center.output}",
        mode     = "${toString _g.monitors.center.res.width}x${toString _g.monitors.center.res.height}@${toString _g.monitors.center.rate}",
        position = "${toString _g.monitors.center.pos.x}x${toString _g.monitors.center.pos.y}",
        scale    = 1,
      })

      hl.monitor({
        output    = "${_g.monitors.right.output}",
        mode      = "${toString _g.monitors.right.res.width}x${toString _g.monitors.right.res.height}",
        position  = "${toString _g.monitors.right.pos.x}x${toString _g.monitors.right.pos.y}",
        scale     = 1,
        transform = 1,
      })
      --- }}}

      --- Core Config --- {{{
      --- https://wiki.hypr.land/Configuring/Basics/Variables/
      hl.config({
        --- general {{{
        general = {
          allow_tearing = true,
          gaps_in       = 5,
          gaps_out      = 10,
          border_size   = 4,
          layout        = useScrolling and "scrolling" or "dwindle",
          col = {
            active_border   = { colors = { "rgba(99c0d0ff)", "rgba(5e81acff)" }, angle = 45 },
            inactive_border = "rgba(2e3440ff)",
            nogroup_border  = "rgba(60728aff)",
          },
        },
        --- }}}
        --- layouts {{{
        dwindle = {
          force_split    = 2,
          preserve_split = true,
        },
        scrolling = {
          focus_fit_method = 0,
        },
        --- }}}
        --- decoration {{{
        decoration = {
          rounding = 7,
        },
        --- }}}
        --- input {{{
        input = {
          kb_layout               = "us",
          repeat_rate             = 80,
          repeat_delay            = 280,
          follow_mouse            = 2,
          mouse_refocus           = false,
          float_switch_override_focus = 0,
          numlock_by_default      = true,
          sensitivity             = 0,
        },
        --- }}}
      }) --- }}}

      --- Animations --- {{{
      --- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

      hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

      hl.animation({ leaf = "windows",     enabled = true, speed = 2, bezier = "myBezier" })
      hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2, bezier = "default",  style = "popin 80%" })
      hl.animation({ leaf = "border",      enabled = true, speed = 2, bezier = "default" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 2, bezier = "default" })
      hl.animation({ leaf = "fade",        enabled = true, speed = 2, bezier = "default" })
      hl.animation({ leaf = "workspaces",  enabled = true, speed = 2, bezier = "default" })
      --- }}}

      --- Environment Variables --- {{{
      --- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

      hl.env("LIBVA_DRIVER_NAME",         "nvidia")
      hl.env("XDG_SESSION_TYPE",          "wayland")
      hl.env("GBM_BACKEND",               "nvidia-drm")
      hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
      hl.env("NVD_BACKEND",               "direct")
      hl.env("XCURSOR_THEME",             "volantes-cursors")
      hl.env("XCURSOR_SIZE",              "24")
      hl.env("HYPRCURSOR_THEME",          "volantes-light-hyprcursor")
      hl.env("HYPRCURSOR_SIZE",           "24")
      --- }}}

      --- Autostart --- {{{
      --- exec-once equivalent: hl.on("hyprland.start", ...)
      --- https://wiki.hypr.land/Configuring/Basics/Autostart/

      hl.on("hyprland.start", function()
        hl.exec_cmd("waypaper --restore")
        hl.exec_cmd("swaync")
        hl.exec_cmd("vicinae server")
        hl.exec_cmd("${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnect")
        hl.exec_cmd("kdeconnect-indicator")
        hl.exec_cmd("blueman-applet")
        hl.exec_cmd("${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse ~/GoogleDrive")
        hl.exec_cmd("xrandr --output DP-1 --primary")
        hl.exec_cmd("uwsm app -- sunshine")
        hl.exec_cmd("trayscale --hide-window")
      end)
      --- }}}

      --- Window Rules --- {{{
      --- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
      --- Rules are matched top-to-bottom; multiple effects can share one match block.

      --- Clipboard (clipse) --- {{{
      hl.window_rule({ match = { class = "^clipse$" },
        float = true, size = "622 652" })
      --- }}}

      --- File Pickers --- {{{
      hl.window_rule({ match = { class = "xdg-desktop-portal(.*)" }, float = true })
      hl.window_rule({ match = { title = "(.*)(Select a)(.*)" },
        size = "1060 960", center = true })
      --- }}}

      --- Firefox Dev Edition – Picture-in-Picture --- {{{
      hl.window_rule({
        match = { class = "^firefox-devedition$", title = "(.*)(Picture-in-Picture)(.*)" },
        float            = true,
        size             = "615 346",
        move             = "1920 56",
        no_initial_focus = true,
      })
      --- }}}

      --- Firefox Nightly – Picture-in-Picture --- {{{
      hl.window_rule({
        match = { class = "^firefox-nightly$", title = "(.*)(Picture-in-Picture)(.*)" },
        float            = true,
        size             = "615 346",
        move             = "1920 56",
        no_initial_focus = true,
      })
      --- }}}

      --- GPG / Pinentry --- {{{
      hl.window_rule({ match = { class = "Pinentry(.*)" }, float = true, center = true })
      --- }}}

      --- Steam --- {{{
      hl.window_rule({
        match     = { class = "^steam_app_(.*)" },
        immediate = true,
        workspace = "7 silent",
        float     = true,
      })
      --- }}}

      --- qBittorrent --- {{{
      hl.window_rule({ match = { class = "^org\\.qbittorrent\\.qBittorrent$" },
        workspace = "9 silent" })
      --- }}}

      --- Streamlink / Chatterino --- {{{
      hl.window_rule({ match = { class = "^streamlink-twitch-gui$" }, workspace = "10 silent" })
      hl.window_rule({ match = { class = "^chatterino$"            }, workspace = "10 silent" })
      --- }}}

      --- CopyQ --- {{{
      hl.window_rule({ match = { class = "^com\\.github\\.hluk\\.copyq$" }, float = true })
      --- }}}

      --- Vencord / Discord --- {{{
      hl.window_rule({ match = { class = "^vencorddesktop$" }, workspace = "10 silent" })
      --- }}}

      --- MPV Picture-in-Picture --- {{{
      hl.window_rule({
        match     = { class = "^mpv_pip$" },
        workspace = "10",
        float     = true,
        size      = "659 369",
        move      = "416 33",
        pin       = true,
      })
      --- }}}

      --- }}}

      --- Workspace Rules --- {{{
      --- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

      hl.workspace_rule({ workspace = "8",  monitor = "${_g.monitors.left.output}",   default = true })
      hl.workspace_rule({ workspace = "1",  monitor = "${_g.monitors.center.output}", default = true })
      hl.workspace_rule({ workspace = "7",  monitor = "${_g.monitors.center.output}" })
      hl.workspace_rule({ workspace = "10", monitor = "${_g.monitors.right.output}",  default = true })
      --- }}}

      --- Key Bindings --- {{{
      --- https://wiki.hypr.land/Configuring/Basics/Binds/
      --- https://wiki.hypr.land/Configuring/Basics/Dispatchers/

      --- Misc --- {{{
      hl.bind(mainMod .. " + BACKSPACE",                 hl.dsp.exec_cmd("kitty"))
      hl.bind(mainMod .. " + Q",                         hl.dsp.window.close())
      hl.bind(mainMod .. " + ALT + ESCAPE",              hl.dsp.exit())
      hl.bind(mainMod .. " + S",                         hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + F",                         hl.dsp.window.fullscreen())
      hl.bind(mainMod .. " + CONTROL + F",               hl.dsp.exec_cmd("nautilus"))
      hl.bind(mainMod .. " + GRAVE",                     hl.dsp.exec_cmd("hdrop -f -b -g 30 kitty --- class kittydrop"))
      hl.bind(mainMod .. " + ALT + L",                   hl.dsp.exec_cmd("~/hypr/swayidle-swaylock-hypr.sh"))
      hl.bind(mainMod .. " + CONTROL + ALT + SHIFT + D", hl.dsp.exec_cmd("~/.local/state/nix/profiles/imperative/bin/xhisper"))
      --- }}}

      --- Launchers --- {{{
      hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd("vicinae open"))
      hl.bind(mainMod .. " + CONTROL + V", hl.dsp.exec_cmd("vicinae 'vicinae://launch/clipboard/history'"))
      --- }}}

      --- Groups --- {{{
      hl.bind(mainMod .. " + G",           hl.dsp.group.toggle())
      hl.bind(mainMod .. " + tab",         hl.dsp.group.next())

      hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.move({ into_group = "l" }))
      hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ into_group = "r" }))
      hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.move({ into_group = "u" }))
      hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.move({ into_group = "d" }))

      hl.bind(mainMod .. " + M",           hl.dsp.window.move({ out_of_group = true }))
      --- }}}

      --- Cycle Floating Windows --- {{{
      hl.bind(mainMod .. " + Tab", function()
        hl.dispatch(hl.dsp.window.cycle_next())
        hl.dispatch(hl.dsp.window.bring_to_top())
      end)
      --- }}}

      --- Layout-Specific Binds --- {{{
      if useScrolling then
        --- Hyprscrolling --- {{{
        hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -conf"))
        hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +conf"))

        hl.bind(mainMod .. " + H", hl.dsp.layout("move -col"))
        hl.bind(mainMod .. " + N", hl.dsp.focus({ direction = "d" }))
        hl.bind(mainMod .. " + E", hl.dsp.focus({ direction = "u" }))
        hl.bind(mainMod .. " + I", hl.dsp.layout("move +col"))

        hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "r" }))
        hl.bind(mainMod .. " + comma",  hl.dsp.focus({ monitor = "l" }))

        hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("swapcol l"),             { repeating = true })
        hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ direction = "d" }), { repeating = true })
        hl.bind(mainMod .. " + SHIFT + E", hl.dsp.window.move({ direction = "u" }), { repeating = true })
        hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("swapcol r"),             { repeating = true })

        --- Move active window to left/right monitor
        hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.window.move({ monitor = "l" }))
        hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "r" }))

        hl.bind(mainMod .. " + X", hl.dsp.layout("promote"))
        hl.bind(mainMod .. " + C", hl.dsp.layout("consume"))
        --- }}}

      else

        --- Dwindle --- {{{
        hl.bind(mainMod .. " + comma",  hl.dsp.focus({ workspace = "m-1" }))
        hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "m+1" }))

        hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
        hl.bind(mainMod .. " + N", hl.dsp.focus({ direction = "d" }))
        hl.bind(mainMod .. " + E", hl.dsp.focus({ direction = "u" }))
        hl.bind(mainMod .. " + I", hl.dsp.focus({ direction = "r" }))

        hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
        hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

        hl.bind(mainMod .. " + CONTROL + SHIFT + E", hl.dsp.layout("preselect u"))
        hl.bind(mainMod .. " + CONTROL + SHIFT + N", hl.dsp.layout("preselect d"))
        hl.bind(mainMod .. " + CONTROL + SHIFT + H", hl.dsp.layout("preselect l"))
        hl.bind(mainMod .. " + CONTROL + SHIFT + I", hl.dsp.layout("preselect r"))
        --- }}}

      end
      --- }}}

      --- Workspace Switching --- {{{
      for i = 1, 10 do
        local key = i % 10  --- key 0 maps to workspace 10
        hl.bind(mainMod .. " + "         .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
      --- }}}

      --- Screenshots --- {{{
      hl.bind("SHIFT + PRINT",   hl.dsp.exec_cmd("hyprshot -m window"))
      hl.bind("PRINT",           hl.dsp.exec_cmd("hyprshot -m output"))
      hl.bind("CONTROL + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
      --- }}}

      --- Volume --- {{{
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      --- }}}

      --- Repeatable Binds --- {{{

      --- Move Floating Windows --- {{{
      hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ x = -10, y = 0,   relative = true }), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ x = 0,   y = 10,  relative = true }), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ x = 0,   y = -10, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ x = 10,  y = 0,   relative = true }), { repeating = true })
      --- }}}

      --- Resize Active Window --- {{{
      hl.bind(mainMod .. " + CONTROL + H",     hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CONTROL + N",     hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CONTROL + E",     hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CONTROL + I",     hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })

      hl.bind(mainMod .. " + CONTROL + left",  hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CONTROL + right", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CONTROL + up",    hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CONTROL + down",  hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
      --- }}}

      --- }}}

      --- Mouse Binds --- {{{
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
      --- }}}

      --- }}}
    '';
  };
  # }}}
}

# vim: foldmethod=marker foldmarker={{{,}}} foldlevel=1
