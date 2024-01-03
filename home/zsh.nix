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
      beep = "echo \"\\a\"";
      latr = "ls -lahtr";
      xclp = "xclip -sel clip";
    };
    initExtra = ''
        # Change to Zsh's default readkey engine
        ZVM_CURSOR_STYLE_ENABLED=false
        ZVM_VI_HIGHLIGHT_FOREGROUND=#bbc2cf
        ZVM_VI_HIGHLIGHT_BACKGROUND=#3e4451
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        zvm_after_init_commands+=('source ${pkgs.fzf}/share/fzf/key-bindings.zsh')
      '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
