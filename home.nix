{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ajrae";
  home.homeDirectory = "/home/ajrae";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    ripgrep
    fd
    htop
  ];

  imports = [
    ./modules/zsh.nix
  ];

  programs.git = {
    enable = true;
    userEmail = "ajrae.nv@gmail.com";
    userName = "Andrew Rae";
    extraConfig.pull.rebase = true;
    extraConfig.init.defaultBranch = "development";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
