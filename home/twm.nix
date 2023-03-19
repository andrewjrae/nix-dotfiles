{ config, lib, pkgs, ... }:

{
  imports = [ ./rofi.nix ];
  # Various packages required by my xmonad config
  home.packages = with pkgs; [
    firefox
    blueberry
    # fsearch
  ];
  services.recoll = {
    enable = true;
    settings = {
      nocjk = true;
      loglevel = 5;
      topdirs = [ "~/" ];
    };
  };
}
