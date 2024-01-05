{ config, pkgs, lib, home-manager, inputs,... }:

{
  imports = [
      ./wezterm.nix
  ];
  # add any global options we want here
  options = with lib; with types; {
    isServer = mkOption {
      type = bool;
      default = false;
    };
  };

  config = {
    home.packages = with pkgs; [
      (ripgrep.override {withPCRE2 = true;})
      fd
      htop
      libqalculate
      wget
    ]
    ++
    (if pkgs.stdenv.isDarwin
     then []
     else [
       gptfdisk
     ]);

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
