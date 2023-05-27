{ config, lib, pkgs, ... }:

{
  imports = [
    ./rofi.nix
    ./spicetify.nix
  ];

  home.file.".background-image".source = ../configs/background-image;

  # Various packages required by both my TWM configs
  home.packages = with pkgs; [
    firefox
    blueberry
    alsa-utils
    playerctl
    flameshot
    pavucontrol
    btop
    vim
    brightnessctl
  ];
  services.recoll = {
    enable = true;
    settings = {
      nocjk = true;
      loglevel = 5;
      topdirs = [ "~/" ];
    };
  };
  services.playerctld.enable = true;
  gtk = {
    enable = true;
    font.name = "Fira Sans";
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
  };
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ../configs/eww;
  };
}
