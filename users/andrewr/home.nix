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
  # need to export this at the front of the path in order to get the correct clang format
  programs.zsh.initExtra = ''
  function cb() {
    global_bashrc="/cb/user_env/bashrc-latest"
    [ -r "$global_bashrc" ] && . "$global_bashrc"
  }
  source ~/.global_bashrc_reduced
  '';
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  programs.git = {
      enable = true;
      userEmail = "andrew.rae@cerebras.net";
      userName = "Andrew Rae";
      extraConfig.pull.rebase = true;
      extraConfig.push.default = "simple";
    };
}
