{ config, lib, pkgs, ... }:

{
  options = with lib; with types; {
    isServer = mkOption {
      type = bool;
      default = false;
    };
  };
}
