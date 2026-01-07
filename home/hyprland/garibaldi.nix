{ config, lib, pkgs, ... }:

{
  hyprMonitorCfg = ''
      # ----- monitor configs -----
      $laptopMonitor = eDP-1, preferred, 0x0, 1
      monitor = $laptopMonitor
      monitor = desc:PXO Pixio PXC348C, preferred, 0x-1440, 1
      bindl =, switch:off:Lid Switch, exec, hyprctl keyword monitor "$laptopMonitor"
      bindl =, switch:on:Lid Switch, exec, ~/.config/hypr/scripts/lidswitch.sh
'';
}
