{ config, pkgs, lib, home-manager, nix-darwin, inputs,... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Emacs overlay for native comp
#  nixpkgs.overlays = [
#    (import (builtins.fetchTarball {
#      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#    }))
#  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    htop
    #xclip
    #fsearch
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
