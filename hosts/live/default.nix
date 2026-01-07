{ config, lib, pkgs, ... }:

{
  imports = [
    ../../nixos/common.nix
  ];

  nix.settings.system-features = [ "nix-command" "flakes" ];
  nix.extraOptions = "experimental-features = nix-command flakes";

  boot= {
    supportedFilesystems = [ "ext4" ];
    loader.grub.device = "/dev/sda";
  };

  environment.systemPackages = with pkgs; [
    git
    tmux
    neovim
  ];
}
