{ config, lib, pkgs, ... }:

{
  imports = [
    ./rofi.nix
    ./spicetify.nix
    ./firefox.nix
  ];

  home.file.".background-image".source = ../configs/background-image;

  # Various packages required by both my TWM configs
  home.packages = with pkgs; [
    blueberry
    alsa-utils
    playerctl
    flameshot
    pavucontrol
    btop
    vim
    brightnessctl
    xfce.thunar
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
    iconTheme = {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };
  };
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = ../configs/eww;
  };
}
