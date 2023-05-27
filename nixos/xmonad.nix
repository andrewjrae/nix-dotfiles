{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.autorandr.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;

    layout = "us";
    xkbVariant = "";
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    # videoDrivers = [ "nvidia" ];
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hpkgs: [
          hpkgs.dbus
        ];
      };
    };
    displayManager = {
      defaultSession = "none+xmonad";
      startx.enable = true;
    };
  };
}
