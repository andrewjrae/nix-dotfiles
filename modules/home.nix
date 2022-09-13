{ config, pkgs, lib, home-manager, inputs,... }:

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

  home.packages = with pkgs; [
    (ripgrep.override {withPCRE2 = true;})
    fd
    htop
    libqalculate
    #xclip
    #fsearch
  ];

  programs.git = if config.home.username == "andrewr"
                 then
                   { enable = false; }
                 else
                   {
                     enable = true;
                     userEmail = "ajrae.nv@gmail.com";
                     userName = "Andrew Rae";
                     extraConfig.pull.rebase = true;
                     extraConfig.init.defaultBranch = "development";
                   };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
