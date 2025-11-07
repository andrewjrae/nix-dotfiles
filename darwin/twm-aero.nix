{ config, lib, pkgs, ... }:

let
  aero-pkg = pkgs.aerospace.overrideAttrs (attrs: {
    src = pkgs.fetchzip {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.19.2-Beta/AeroSpace-v0.19.2-Beta.zip";
      sha256 = "sha256-rF4emnLNVE1fFlxExliN7clSBocBrPwQOwBqRtX9Q4o=";
    };
  });
in {
  users.users.ajrae.packages = with pkgs; [
    autoraise
  ];

  services.aerospace = {
    enable = true;
    package = aero-pkg;
    settings = {
      gaps = {
        outer.left = 9;
        outer.bottom = 9;
        outer.top = 9;
        outer.right = 9;
      };
      mode.main.binding = {
        # apps
        ctrl-t = "exec-and-forget open -n -a wezterm";
        ctrl-cmd-d = "exec-and-forget open -n -a wezterm --args connect dev";
        ctrl-i = "exec-and-forget open -a ~/Applications/Home\ Manager\ Apps/Alacritty.app";
        ctrl-b = "exec-and-forget open -a Firefox";
        ctrl-o = "exec-and-forget open -a 'Microsoft Outlook'";
        ctrl-s = "exec-and-forget open -a Slack";
        ctrl-m = "exec-and-forget open -a Spotify";
        ctrl-e = "exec-and-forget open -a ~/Applications/Home\ Manager\ Apps/Emacs.app";
        ctrl-q = "exec-and-forget open -n -a wezterm --args start -- qalc";
        ctrl-p = "rofi-pass";
        # regular wm commands
        ctrl-n = "focus dfs-next";
        ctrl-a = "focus dfs-prev";
        ctrl-x = "close";
        ctrl-1 = "workspace 1";
        ctrl-2 = "workspace 2";
        ctrl-3 = "workspace 3";
        ctrl-4 = "workspace 4";
        ctrl-5 = "workspace 5";
        ctrl-6 = "workspace 6";
        ctrl-7 = "workspace 7";
        ctrl-8 = "workspace 8";
        ctrl-9 = "workspace 9";
        ctrl-cmd-1 = "move-node-to-workspace 1";
        ctrl-cmd-2 = "move-node-to-workspace 2";
        ctrl-cmd-3 = "move-node-to-workspace 3";
        ctrl-cmd-4 = "move-node-to-workspace 4";
        ctrl-cmd-5 = "move-node-to-workspace 5";
        ctrl-cmd-6 = "move-node-to-workspace 6";
        ctrl-cmd-7 = "move-node-to-workspace 7";
        ctrl-cmd-8 = "move-node-to-workspace 8";
        ctrl-cmd-9 = "move-node-to-workspace 9";
        ctrl-space = "workspace-back-and-forth";
        ctrl-cmd-space = "move-workspace-to-monitor --wrap-around next";
      };
      on-focus-changed = ["move-mouse window-lazy-center"];
    };
  };

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
  };

  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;
    width = 6.0;
    active_color = "0xffc678dd";
    inactive_color = "0xff4c566a";
  };


}
