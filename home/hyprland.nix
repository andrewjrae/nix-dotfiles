{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./twm.nix
  ];

  home.packages = with pkgs; [
    swaybg
    mako
    socat
    jaq
    grim
    slurp
    wl-clipboard
    tessen
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = ''
      # ----- setup -----
      env = XDG_CURRENT_DESKTOP, Hyprland
      env = XDG_SESSION_TYPE, wayland
      env = XDG_SESSION_DESKTOP, Hyprland
      env = MOZ_ENABLE_WAYLAND, 1
      exec-once = swaybg -i ~/.background-image -m fill
      exec-once = eww daemon
      exec-once = eww open bar
      exec-once = moka
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
            new_is_master = true
            new_on_top = true
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
            blur = false
            drop_shadow = false
      }
      # touchpad settings
      input {
            touchpad {
                  natural_scroll = true
                  scroll_factor = 0.25
            }
      }
      gestures {
            workspace_swipe = true
            workspace_swipe_distance = 150
      }
      # misc
      misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            enable_swallow = true
            swallow_regex = Alacritty
      }
      # animations:enabled = false
      # ----- keybinds -----
      $browser = firefox
      $terminal = alacritty
      # the essentials
      bind = SUPER, b, exec, $browser
      bind = SUPER, e, exec, emacsclient -c -a emacs
      bind = SUPER, t, exec, $terminal
      bind = SUPER, h, exec, $terminal -e htop
      bind = SUPER, q, exec, $terminal -e qalc
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
      bind =, xf86monbrightnessup,  exec, brightnessctl s +5%
      bind =, xf86monbrightnessdown, exec, brightnessctl s 5%-
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
      # ----- monitor configs -----
      $laptopMonitor = eDP-1, preferred, 1920x0, 1
      monitor = $laptopMonitor
      monitor = desc:PXO Pixio PXC348C, 3440x1440@30, 0x0, 1
      bindl =, switch:off:Lid Switch, exec, hyprctl keyword monitor "$laptopMonitor"
      bindl =, switch:on:Lid Switch, exec, ~/.config/hypr/lidswitch.sh
      # ----- window rules -----
      windowrule = float, blueberry
    '';
  };
  xdg.configFile."hypr/lidswitch.sh".source = ../configs/hypr/lidswitch.sh;
}
