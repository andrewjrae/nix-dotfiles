{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira
    fira-code
    fira-code-symbols
  ];
}
