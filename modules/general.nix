{ config, pkgs, lib, home-manager, inputs,... }:

{
  home.packages = with pkgs; [
    (ripgrep.override {withPCRE2 = true;})
    fd
    htop
    libqalculate
    #xclip
    #fsearch
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
