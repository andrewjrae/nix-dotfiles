{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
    wezterm.terminfo
  ];
  xdg.configFile."wezterm/wezterm.lua".source = ../configs/wezterm/wezterm.lua;
}
