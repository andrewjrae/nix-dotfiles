{ config, lib, pkgs, ... }:

{
  imports = [
      ./general.nix
      ./pass.nix
      ./zsh.nix
      ./fonts.nix
      ./emacs.nix
      ./alacritty.nix
  ];
}
