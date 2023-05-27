{ config, lib, pkgs, ... }:

{
  # add any global options we want here
  options = with lib; with types; {
    wmCmd = mkOption {
      type = str;
      default = "startx";
    };
  };
}
