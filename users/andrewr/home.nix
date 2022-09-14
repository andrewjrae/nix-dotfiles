{ config, pkgs, lib, inputs,... }:

{
  home.username = "andrewr";
  home.homeDirectory = "/cb/home/andrewr";
  home.stateVersion = "22.05";
  programs.zsh.initExtraFirst = ''ZSH_DISABLE_COMPFIX="true"'';
}
