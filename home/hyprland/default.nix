{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../twm.nix
  ];

  
  options = with lib; with types; {
    hyprMonitorCfg = mkOption {
      type = str;
      default = "";
    };
  };

  config = {
    services.mako = {
      enable = true;
      settings.default-timeout = 2500;
    };

    home.packages = with pkgs; [
      swaybg
      socat
      jaq
      grim
      slurp
      wl-clipboard
      tessen
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      extraConfig = ''
      # ----- setup -----
      env = XDG_CURRENT_DESKTOP, Hyprland
      env = XDG_SESSION_TYPE, wayland
      env = XDG_SESSION_DESKTOP, Hyprland
      env = MOZ_ENABLE_WAYLAND, 1
      exec-once = swaybg -i ~/.background-image -m fill
      exec-once = eww daemon
      exec-once = eww open bar
      # ----- variables -----
      general {
            layout = master
            border_size = 2
            gaps_in = 4
            gaps_out = 8
            col.active_border = rgb(c678dd)
            col.inactive_border = rgb(4c566a)
            resize_on_border = true
      }
      master {
            mfact = 0.45
            new_on_active = before
            orientation = center
      }
      binds {
            # this makes workspace previous work as expected
            allow_workspace_cycles = true
      }
      # decorations
      decoration {
            rounding = 4
            active_opacity = 0.99
            inactive_opacity = 0.97
            fullscreen_opacity = 1.0
            # turn off for power saving
            blur:enabled = false
            shadow:enabled = false
      }
      # touchpad settings
      input {
            touchpad {
                  natural_scroll = true
                  scroll_factor = 0.25
            }
      }
      gestures {
            workspace_swipe_touch = true
            workspace_swipe_distance = 150
      }
      # misc
      misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            enable_swallow = false
            swallow_regex = Alacritty
      }
      cursor {
        hide_on_key_press = true
        inactive_timeout = 5
        # persistent_warps = true
      }
      animations:enabled = false
      # ----- keybinds -----
      $browser = firefox
      $terminal = wezterm
      $terminal-run = wezterm start --
      # the essentials
      bind = SUPER, b, exec, $browser
      bind = SUPER, e, exec, emacsclient -c -a emacs
      bind = SUPER, t, exec, $terminal
      bind = SUPER, h, exec, $terminal-run htop
      bind = SUPER, q, exec, $terminal-run qalc
      # rofi (and other launchers)
      bind = SUPER, r, exec, rofi -show run
      bind = SUPER, s, exec, rofi -show ssh
      bind = SUPER, w, exec, rofi -show windows
      bind = SUPER, o, exec, emacsclient -e '(emacs-run-recoll)'
      bind = SUPER, p, exec, tessen -d rofi
      # exit
      bind = SHIFT SUPER, q, exec, hyprctl dispatch exit
      # window misc
      bind = SUPER, x, killactive
      bind = SUPER, f, fullscreen, 1
      bind = CTRL SUPER, f, fullscreen, 0
      # window movement
      bind = SUPER, j, layoutmsg, cyclenext
      bind = SUPER, n, layoutmsg, cyclenext
      bind = SUPER, k, layoutmsg, cycleprev
      bind = SUPER, a, layoutmsg, cycleprev
      # window swaps
      bind = CTRL SUPER, j, layoutmsg, swapnext
      bind = CTRL SUPER, n, layoutmsg, swapnext
      bind = CTRL SUPER, k, layoutmsg, swapprev
      bind = CTRL SUPER, a, layoutmsg, swapprev
      # window resizing
      binde = SUPER, LEFT, resizeactive, -20 0
      binde = SUPER, RIGHT, resizeactive, 20 0
      binde = SUPER, UP, resizeactive, 0 -20
      binde = SUPER, DOWN, resizeactive, 0 20
      # monitors
      bind = CTRL SUPER, SPACE, focusmonitor, +1
      bind = SHIFT CTRL SUPER, SPACE, movecurrentworkspacetomonitor, +1
      # workspace movement
      bind = SUPER, SPACE, workspace, previous
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER CTRL, 1, movetoworkspacesilent, 1
      bind = SUPER CTRL, 2, movetoworkspacesilent, 2
      bind = SUPER CTRL, 3, movetoworkspacesilent, 3
      bind = SUPER CTRL, 4, movetoworkspacesilent, 4
      bind = SUPER CTRL, 5, movetoworkspacesilent, 5
      bind = SUPER CTRL, 6, movetoworkspacesilent, 6
      bind = SUPER CTRL, 7, movetoworkspacesilent, 7
      bind = SUPER CTRL, 8, movetoworkspacesilent, 8
      bind = SUPER CTRL, 9, movetoworkspacesilent, 9
      # mouse binds
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      # media keys
      bind =, xf86audiomute, exec, amixer -q set Master toggle
      bind =, xf86audiolowervolume, exec, amixer -q set Master 5%-
      bind =, xf86audioraisevolume, exec, amixer -q set Master 5%+
      bind =, xf86monbrightnessup,  exec, ~/.config/hypr/scripts/brightness.sh +5%
      bind =, xf86monbrightnessdown, exec, ~/.config/hypr/scripts/brightness.sh 5%-
      bind =, xf86audioplay, exec, playerctl play-pause
      bind =, xf86audionext, exec, playerctl next
      bind =, xf86audioprev, exec, playerctl previous
      bind =, xf86audiostop, exec, playerctl stop
      # screenshots
      bind =, Print, exec, grim -g "$(slurp)" - | wl-copy -t image/png
      bind = SHIFT CTRL, PRINT, exec, grim -g "$(slurp)" - | wl-copy -t image/png
      # ----- animations -----
      animation = windows, 1, 8, default, popin
      animation = windowsMove, 0, 8, default
      animation = fade, 0, 8, default
      animation = border, 0, 8, default
      # ----- window rules -----
      #windowrule = float, blueberry
      '' + config.hyprMonitorCfg;
    };
    xdg.configFile."hypr/scripts".source = ../../configs/hypr/scripts;
  };
}
