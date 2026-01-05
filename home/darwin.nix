{ config, lib, pkgs, ... }:

{
  imports = [
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    monitorcontrol
  ];
}
