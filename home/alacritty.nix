{ config, lib, pkgs, ... }:

let
  alacrittyConfig = (if pkgs.stdenv.isDarwin
                     then ../configs/alacritty/darwin.yml
                     else ../configs/alacritty/linux.yml);
in
{
  home.packages = with pkgs; [
    alacritty
  ];
  xdg.configFile."alacritty/base_config.yml".source = ../configs/alacritty/base_config.yml;
  xdg.configFile."alacritty/alacritty.yml".source = alacrittyConfig;
}
