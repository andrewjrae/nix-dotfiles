{ config, lib, pkgs, ... }:

{
  xdg.configFile."oh-my-zsh/themes/ajrae.zsh-theme".source = ../configs/oh-my-zsh/ajrae.zsh-theme;
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "ajrae";
      custom = "$HOME/.config/oh-my-zsh";
      plugins = [ "git" "sudo"];
    };
    shellAliases = {
      psrg = "ps -aux | rg -i";
      xclp = "xclip -sel clip";
    };
    initExtra = "set -o vi";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
