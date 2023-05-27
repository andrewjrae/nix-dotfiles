{ config, lib, pkgs, ... }:
{
  imports = [
    ./twm.nix
  ];

  # xinit for xmonad
  home.file.".xinitrc".text = ''
    #!/bin/sh
    export XDG_SESSION_TYPE=x11
    export XDG_SESSION_DESKTOP=xmonad
    export XDG_CURRENT_DESKTOP=xmonad
    exec xmonad
  '';

  # Various packages required by my xmonad config
  home.packages = with pkgs; [
    wmctrl
    escrotum
    nitrogen
  ];
  services.picom = {
    enable = true;
    settings = {
      corner-radius = 5;
    };
  };
  services.unclutter.enable = true;
}
