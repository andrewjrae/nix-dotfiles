{ config, lib, pkgs, ... }:

{

 services.yabai = {
   enable = true;
   enableScriptingAddition = true;
   package = pkgs.yabai;
   config = {
     # layout
     layout = "bsp";
     # layout = "stack";
     auto_balance = "off";
     split_ratio = "0.50";
     window_placement = "second_child";
     # Gaps
     window_gap = 5;
     top_padding = 5;
     bottom_padding = 5;
     left_padding = 5;
     right_padding = 5;
     # shadows and borders
     window_shadow = "on";
     window_border = "off";
     window_border_width = 3;
     normal_window_border_color = "0x4c566a";
     active_window_border_color = "0xc678dd";
     window_opacity = "on";
     window_opacity_duration = "0.1";
     active_window_opacity = "1.0";
     normal_window_opacity = "0.97";
     # mouse
     mouse_modifier = "cmd";
     mouse_action1 = "move";
     mouse_action2 = "resize";
     mouse_drop_action = "swap";
     focus_follows_mouse = "autoraise";
     mouse_follows_focus = "on";
   };
   extraConfig = ''
     # rules
     yabai -m rule --add app=emacsclient manage=on
     yabai -m rule --add app=emacs manage=on
     yabai -m rule --add app=Emacs manage=on
     yabai -m rule --add app='Alacritty' manage=on
     yabai -m rule --add app='Firefox' manage=on
     yabai -m rule --add app='System Preferences' manage=off
     yabai -m rule --add app='Spotlight' manage=off
     yabai -m rule --add app='Activity Monitor' manage=off
     yabai -m rule --add app='Karabiner-Elements' manage=off
     yabai -m rule --add app='Finder' manage=off
     yabai -m rule --add app='Microsoft Teams' manage=off
     yabai -m rule --add app='zoom.us' manage=off
   '';
 };


 services.skhd = {
   enable = true;
   package = pkgs.skhd;
   skhdConfig = let
        passthru = key: ''skhd -k "hyper - 1" ; skhd -k "${key}" ; skhd -k "hyper - 1"'';
        passthru-except-term = key:
        ''[
             "Alacritty" ~
             "emacs" ~
             * : ${passthru key}
          ]'';
     in
        ''
     :: default
     :: passthru

     ########## Yabai bindings
     # open to apps
     cmd - t : open -n -a Alacritty
     cmd - b : open -a Firefox
     cmd - o : open -a "Microsoft Outlook"
     cmd - s : open -a Slack
     cmd - m : open -a Spotify
     # cmd - e : emacsclient -c -a emacs
     cmd - e : open -a Emacs
     cmd - r : ${passthru "cmd - space"}

     # focus window
     cmd - n : yabai -m window --focus next
     cmd - a : yabai -m window --focus prev

     # move windows
     ctrl + cmd - n : yabai -m window --swap next
     ctrl + cmd - a : yabai -m window --swap prev

     # close window
     cmd - x : yabai -m window --close

     # focus spaces
     cmd - space : yabai -m space --focus recent
     cmd - 1 : yabai -m space --focus 1
     cmd - 2 : yabai -m space --focus 2
     cmd - 3 : yabai -m space --focus 3
     cmd - 4 : yabai -m space --focus 4
     cmd - 5 : yabai -m space --focus 5
     cmd - 6 : yabai -m space --focus 6
     cmd - 7 : yabai -m space --focus 7
     cmd - 8 : yabai -m space --focus 8

     # send window to desktop
     ctrl + cmd - space : yabai -m window --space recent
     ctrl + cmd - 1 : yabai -m window --space 1
     ctrl + cmd - 2 : yabai -m window --space 2
     ctrl + cmd - 3 : yabai -m window --space 3
     ctrl + cmd - 4 : yabai -m window --space 4
     ctrl + cmd - 5 : yabai -m window --space 5
     ctrl + cmd - 6 : yabai -m window --space 6
     ctrl + cmd - 7 : yabai -m window --space 7
     ctrl + cmd - 8 : yabai -m window --space 8

     # float / unfloat window and center on screen
     # lalt - t : yabai -m window --toggle float;\
     #            yabai -m window --grid 4:4:1:1:2:2

     # toggle window zoom
     cmd - f : yabai -m window --toggle zoom-parent
     ctrl + cmd - f : yabai -m window --toggle zoom-fullscreen

     # change layout
     ctrl + cmd - s : yabai -m space --layout bsp
     ctrl + cmd - t : yabai -m space --layout float



     ########## PC-style bindings
     # need this passthru hack to avoid calling back into skhd
     hyper - 1 ; passthru
     passthru < hyper - 1 ; default

     home ${passthru-except-term "cmd - left"}
     end ${passthru-except-term "cmd - right"}
     ctrl - a ${passthru-except-term "cmd - a"}
     ctrl - p ${passthru-except-term "cmd - p"}
     ctrl - c ${passthru-except-term "cmd - c"}
     ctrl - v ${passthru-except-term "cmd - v"}
     ctrl - z ${passthru-except-term "cmd - z"}
     ctrl - y ${passthru-except-term "shift + cmd - z"}
     ctrl - f ${passthru-except-term "cmd - f"}
     ctrl - t ${passthru-except-term "cmd - t"}
     ctrl - k ${passthru-except-term "cmd - k"}
     ctrl - w ${passthru-except-term "cmd - w"}
     ctrl - insert ${passthru-except-term "cmd - c"}
     shift - insert ${passthru-except-term "cmd - v"}
     ctrl - left ${passthru-except-term "alt - left"}
     ctrl - right ${passthru-except-term "alt - right"}
     ctrl - down ${passthru-except-term "alt - down"}
     ctrl - up ${passthru-except-term "alt - up"}
     shift - home ${passthru-except-term "shift + cmd - left"}
     shift - end ${passthru-except-term "shift + cmd - right"}
     shift + ctrl - left ${passthru-except-term "shift + alt - left"}
     shift + ctrl - right ${passthru-except-term "shift + alt - right"}
     shift + ctrl - down ${passthru-except-term "shift + alt - down"}
     shift + ctrl - up ${passthru-except-term "shift + alt - up"}
     ctrl - s ${passthru-except-term "cmd - s"}
     ctrl - backspace ${passthru-except-term "alt - backspace"}
     ctrl - delete ${passthru-except-term "alt - delete"}
   '';
 };

 services.spacebar = {
   enable = true;
   package = pkgs.spacebar;
   config = {
     position = "top";
     height = 32;
     title = "off";
     spaces = "on";
     power = "on";
     clock = "on";
     right_shell = "off";
     padding_left = 20;
     padding_right = 20;
     spacing_left = 25;
     spacing_right = 25;
     text_font = ''"Fira Sans:Regular:16.0"'';
     icon_font = ''"Font Awesome 5 Free:Solid:14.0"'';
     background_color = "0x44282c34";
     foreground_color = "0xffbbc2cf";
     space_icon_color = "0xffc678dd";
     power_icon_color = "0xff98be65";
     battery_icon_color = "0xffecbe7b";
     power_icon_strip = " ";
     space_icon_strip = "1 2 3 4 5 6 7 8 9";
     spaces_for_all_displays = "on";
     display_separator = "on";
     display_separator_icon = "|";
     clock_format = ''"%d/%m/%y %R"'';
     right_shell_icon = " ";
     right_shell_command = "whoami";
   };
 };
}
