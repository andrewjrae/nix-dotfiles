{ config, pkgs, lib, home-manager, inputs,... }:

{
  # home.username = "ajrae";
  # home.homeDirectory = "/home/ajrae";
  home.stateVersion = "22.05";

  programs.git = {
    enable = true;
    settings = {
      user.email = "ajrae.nv@gmail.com";
      user.name = "Andrew Rae";
      pull.rebase = true;
      init.defaultBranch = "development";
    };
  };

  home.sessionVariables = {
    TERMINAL = "wezterm";
  };

  programs.zsh.shellAliases = { ecli = "TERM=alacritty-direct emacsclient -t"; };
}
