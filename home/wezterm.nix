{ config, lib, pkgs, ... }:

let
  wezterm-git = pkgs.wezterm.overrideAttrs (old: rec {
    src = pkgs.fetchFromGitHub {
      owner = "wez";
      repo = "wezterm";
      rev = "4921f139d35590ab35415021221a2a6f5cf10ab3";
      fetchSubmodules = true;
      hash = "sha256-WXOsP2rjbT4unc7lXbxbRbCcrc89SfyVdErzFndBF9o=";
    };
    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = src.outPath + "/Cargo.lock";
      outputHashes = {
        "xcb-1.2.1" = "sha256-zkuW5ATix3WXBAj2hzum1MJ5JTX3+uVQ01R1vL6F1rY=";
        "xcb-imdkit-0.2.0" = "sha256-L+NKD0rsCk9bFABQF4FZi9YoqBHr4VAZeKAWgsaAegw=";
      };
    };
    version = "git-${src.rev}";
  });
in
{
  home.packages = with pkgs; [
    wezterm-git
    wezterm-git.terminfo
  ];
  xdg.configFile."wezterm/wezterm.lua".source = ../configs/wezterm/wezterm.lua;
}
