{ config, lib, pkgs, ... }:

{
  imports = [
      ./common.nix
      ./pass.nix
      ./zsh.nix
      ./fonts.nix
      ./emacs.nix
      ./wezterm.nix
      # ./alacritty.nix
  ];
}
