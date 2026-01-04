{ config, lib, pkgs, ... }:

{
  users.users.ajrae.packages = with pkgs; [
    yabai
    skhd
  ];
  services.yabai = {
    enable = true;
    enableScriptingAddition = false;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "off";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      external_bar = "all:32:0";
      window_gap = 12;
      top_padding = 9;
      bottom_padding = 9;
      left_padding = 9;
      right_padding = 9;
      # shadows and borders
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
     yabai -m rule --add label=emacs manage=on
     yabai -m rule --add app=emacs manage=on
     yabai -m rule --add app='emacs-28.2' manage=on
     yabai -m rule --add app=Emacs manage=on
     yabai -m rule --add app=WezTerm manage=on
     yabai -m rule --add app='Firefox' manage=on
     yabai -m rule --add app='System Preferences' manage=off
     yabai -m rule --add app='Spotlight' manage=off
     yabai -m rule --add app='Activity Monitor' manage=off
     yabai -m rule --add app='Karabiner-Elements' manage=off
     yabai -m rule --add app='Finder' manage=off
     yabai -m rule --add app='Microsoft Teams' manage=off
     yabai -m rule --add app='zoom.us' manage=off
     yabai -m rule --add title='floating-qalc' manage=off
     yabai -m signal --add event=space_changed action='echo $YABAI_RECENT_SPACE_ID > /tmp/yabai-last-space' active=yes
   '';
  };

  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;
    width = 6.0;
    active_color = "0xffc678dd";
    inactive_color = "0xff4c566a";
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = let
      passthru = key: ''skhd -k "hyper - 1" ; skhd -k "${key}" ; skhd -k "hyper - 1"'';
      remap-for-mac = key:
        ''[
             "Alacritty" ~
             "emacs" ~
             "wezterm" ~
             "wezterm-gui" ~
             * : ${passthru key}
        ]'';
      focus-space = index: ''skhd -k "ctrl - ${index}"'';
      last-space-index = ''$(yabai -m query --spaces | jq --argjson id `cat /tmp/yabai-last-space` '.[] | select(.id == $id).index')'';
    in
      ''
     :: default
     :: passthru

     ########## Yabai bindings
     # open to apps
     # cmd - t : open -n -a ~/Applications/Home\ Manager\ Apps/Alacritty.app
     cmd - t : open -n -a wezterm
     ctrl + cmd - d : open -n -a wezterm --args connect dev
     cmd - i : open -a ~/Applications/Home\ Manager\ Apps/Alacritty.app
     cmd - b : open -a Firefox
     cmd - o : open -a "Microsoft Outlook"
     cmd - s : open -a Slack
     cmd - m : open -a Spotify
     # cmd - e : emacsclient -c -a emacs
     cmd - e : open -a ~/Applications/Home\ Manager\ Apps/Emacs.app
     cmd - r : ${passthru "cmd - space"}
     cmd - q : open -n -a wezterm --args start -- qalc
     cmd - p : rofi-pass

     # focus window
     cmd - n : yabai -m window --focus next
     cmd - a : yabai -m window --focus prev

     # move windows
     ctrl + cmd - n : yabai -m window --swap next
     ctrl + cmd - a : yabai -m window --swap prev

     # close window
     cmd - x : yabai -m window --close

     # focus other display
     ctrl + cmd - space : yabai -m display --focus recent

     # focus spaces
     cmd - space : ${focus-space last-space-index}
     cmd - 1 : ${focus-space "1"}
     cmd - 2 : ${focus-space "2"}
     cmd - 3 : ${focus-space "3"}
     cmd - 4 : ${focus-space "4"}
     cmd - 5 : ${focus-space "5"}
     cmd - 6 : ${focus-space "6"}
     cmd - 7 : ${focus-space "7"}
     cmd - 8 : ${focus-space "8"}
     cmd - 9 : ${focus-space "9"}

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
     ctrl + cmd - h : yabai -m space --layout float

     # change theme
     ctrl + cmd - t : osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'

     # window resizing
     cmd - left : yabai -m window --resize right:-20:0 2> /dev/null || yabai -m window --resize left:-20:0 2> /dev/null
     # cmd - down : yabai -m window --resize bottom:0:20 2> /dev/null || yabai -m window --resize top:0:20 2> /dev/null
     # cmd - up : yabai -m window --resize bottom:0:-20 2> /dev/null || yabai -m window --resize top:0:-20 2> /dev/null
     cmd - right : yabai -m window --resize right:20:0 2> /dev/null || yabai -m window --resize left:20:0 2> /dev/null


     ########## PC-style bindings
     # need this passthru hack to avoid calling back into skhd
     hyper - 1 ; passthru
     passthru < hyper - 1 ; default

     home ${remap-for-mac "cmd - left"}
     end ${remap-for-mac "cmd - right"}
     ctrl - a ${remap-for-mac "cmd - a"}
     ctrl - b ${remap-for-mac "cmd - b"}
     ctrl - i ${remap-for-mac "cmd - i"}
     ctrl - p ${remap-for-mac "cmd - p"}
     ctrl - c ${remap-for-mac "cmd - c"}
     ctrl - v ${remap-for-mac "cmd - v"}
     ctrl - z ${remap-for-mac "cmd - z"}
     ctrl - y ${remap-for-mac "shift + cmd - z"}
     ctrl - f ${remap-for-mac "cmd - f"}
     ctrl - t ${remap-for-mac "cmd - t"}
     ctrl - k ${remap-for-mac "cmd - k"}
     ctrl - w ${remap-for-mac "cmd - w"}
     ctrl - n ${remap-for-mac "cmd - n"}
     ctrl - insert ${remap-for-mac "cmd - c"}
     shift - insert ${remap-for-mac "cmd - v"}
     ctrl - left ${remap-for-mac "alt - left"}
     ctrl - right ${remap-for-mac "alt - right"}
     ctrl - down ${remap-for-mac "alt - down"}
     ctrl - up ${remap-for-mac "alt - up"}
     shift - home ${remap-for-mac "shift + cmd - left"}
     shift - end ${remap-for-mac "shift + cmd - right"}
     shift + ctrl - left ${remap-for-mac "shift + alt - left"}
     shift + ctrl - right ${remap-for-mac "shift + alt - right"}
     shift + ctrl - down ${remap-for-mac "shift + alt - down"}
     shift + ctrl - up ${remap-for-mac "shift + alt - up"}
     ctrl - s ${remap-for-mac "cmd - s"}
     ctrl - backspace ${remap-for-mac "alt - backspace"}
     ctrl - delete ${remap-for-mac "alt - delete"}
     shift + ctrl - t ${remap-for-mac "shift + cmd - t"}
     # screen shots
     0x69 : ${passthru "shift + cmd - 3"}
     shift + ctrl - 0x69 : ${passthru "shift + ctrl + cmd - 4"}
   '';
  };

  services.sketchybar = {
    enable = true;
    config = ''
PLUGIN_DIR=~/SketchyBar/plugins


##### Bar Appearance #####
# Configuring the general appearance of the bar.
# These are only some of the options available. For all options see:
# https://felixkratz.github.io/SketchyBar/config/bar
# If you are looking for other colors, see the color picker:
# https://felixkratz.github.io/SketchyBar/config/tricks#color-picker

sketchybar --bar position=top height=32 blur_radius=30 color=0x40000000

##### Changing Defaults #####
# We now change some default values, which are applied to all further items.
# For a full list of all available item properties see:
# https://felixkratz.github.io/SketchyBar/config/items

default=(
  padding_left=5
  padding_right=5
  icon.font="Font Awesome 5 Free:Solid:14.0"
  label.font="Fira Sans:Regular:16.0"
  icon.color=0xffffffff
  label.color=0xffffffff
  icon.padding_left=4
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=4
)
sketchybar --default "''${default[@]}"

##### Adding Mission Control Space Indicators #####
# Let's add some mission control spaces:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
# to indicate active and available mission control spaces.

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
for i in "''${!SPACE_ICONS[@]}"
do
  sid="$(($i+1))"
  space=(
    space="$sid"
    icon="''${SPACE_ICONS[i]}"
    icon.padding_left=7
    icon.padding_right=7
    background.color=0x40ffffff
    background.corner_radius=5
    background.height=25
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
    click_script="yabai -m space --focus $sid"
  )
  sketchybar --add space space."$sid" left --set space."$sid" "''${space[@]}"
done

##### Adding Right Items #####
# In the same way as the left items we can add items to the right side.
# Additional position (e.g. center) are available, see:
# https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

# Some items refresh on a fixed cycle, e.g. the clock runs its script once
# every 10s. Other items respond to events they subscribe to, e.g. the
# volume.sh script is only executed once an actual change in system audio
# volume is registered. More info about the event system can be found here:
# https://felixkratz.github.io/SketchyBar/config/events

sketchybar --add item clock right \
           --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh" \
           --add item battery right \
           --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change

##### Force all scripts to run the first time (never do this in a script) #####
sketchybar --update
    '';
  };
  # services.spacebar = {
  #   enable = true;
  #   package = pkgs.spacebar;
  #   config = {
  #     position = "top";
  #     height = 32;
  #     title = "off";
  #     spaces = "on";
  #     power = "on";
  #     clock = "on";
  #     right_shell = "off";
  #     padding_left = 20;
  #     padding_right = 20;
  #     spacing_left = 25;
  #     spacing_right = 25;
  #     text_font = ''"Fira Sans:Regular:16.0"'';
  #     icon_font = ''"Font Awesome 5 Free:Solid:14.0"'';
  #     background_color = "0x88282c34";
  #     foreground_color = "0xffbbc2cf";
  #     space_icon_color = "0xffc678dd";
  #     power_icon_color = "0xff98be65";
  #     battery_icon_color = "0xffecbe7b";
  #     power_icon_strip = " ";
  #     space_icon_strip = "1 2 3 4 5 6 7 8 9";
  #     spaces_for_all_displays = "on";
  #     display_separator = "on";
  #     display_separator_icon = "|";
  #     clock_format = ''"%d/%m/%y %R"'';
  #     right_shell_icon = " ";
  #     right_shell_command = "whoami";
  #   };
  # };
}
