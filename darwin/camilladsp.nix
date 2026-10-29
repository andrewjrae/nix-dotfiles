{ config, lib, pkgs, ... }:

{
  homebrew = {
    casks = [
      "blackhole-2ch"
    ];
  };

  users.users.ajrae.packages = with pkgs; [
    camilladsp
  ];

  launchd.user.agents.camilladsp = {
    command = "${pkgs.camilladsp}/bin/camilladsp /Users/ajrae/.config/camilladsp/config.yaml";

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;

      # Optional: Capture logs to easily debug any audio routing or config parsing issues
      StandardOutPath = "/tmp/camilladsp.out.log";
      StandardErrorPath = "/tmp/camilladsp.err.log";
    };
  };
}
