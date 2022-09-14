{ config, pkgs, lib, inputs,... }:

{
  home.username = "andrewr";
  home.homeDirectory = "/cb/home/andrewr";
  home.stateVersion = "22.05";
  # patch some hackiness with the user chroot situation
  programs.zsh.initExtraFirst = ''
   . $HOME/.nix-profile/etc/profile.d/nix.sh
   export SHELL=$(which zsh)
   ZSH_DISABLE_COMPFIX="true"
  '';
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
