{ config, lib, pkgs, ... }:

{
  imports = [
      ./common.nix
      ./pass.nix
      ./zsh.nix
      ./fonts.nix
      ./emacs.nix
      ./alacritty.nix
      ./wezterm.nix
  ];
}
