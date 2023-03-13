{ config, pkgs, lib, home-manager, inputs,... }:

{
  # home.username = "ajrae";
  # home.homeDirectory = "/home/ajrae";
  home.stateVersion = "22.05";

  programs.git = {
      enable = true;
      userEmail = "ajrae.nv@gmail.com";
      userName = "Andrew Rae";
      extraConfig.pull.rebase = true;
      extraConfig.init.defaultBranch = "development";
    };

  programs.zsh.shellAliases = { ecli = "TERM=alacritty-direct emacsclient -t"; };
}
