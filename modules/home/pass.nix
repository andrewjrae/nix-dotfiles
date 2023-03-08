{ config, lib, pkgs, ... }:

{
  programs.gpg.enable = true;
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
      PASSWORD_STORE_CLIP_TIME = "60";
    };
  };
  # passff-host is only actually setup for linux
  # it uses the wrong paths for macos
  # home.packages =  [ pkgs.passff-host ];
}
