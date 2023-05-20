{ config, lib, pkgs, ... }:
{
  imports = [
    ./rofi.nix
    # ./spicetify.nix
  ];
  # Various packages required by my xmonad config
  home.packages = with pkgs; [
    firefox
    blueberry
    wmctrl
    eww
    alsa-utils
    playerctl
    flameshot
    escrotum
    pavucontrol
    btop
  ];
  services.recoll = {
    enable = true;
    settings = {
      nocjk = true;
      loglevel = 5;
      topdirs = [ "~/" ];
    };
  };
  services.picom = {
    enable = true;
    settings = {
      corner-radius = 5;
    };
  };
  services.playerctld.enable = true;
  services.unclutter.enable = true;
  gtk = {
    enable = true;
    font.name = "Fira Sans";
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
  };
  # programs.eww = {
  #   enable = true;
  #   configDir = ../configs/eww;
  # };
}
