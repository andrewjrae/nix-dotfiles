{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.autorandr.enable = true;
  services.xserver = {
    enable = true;
    autorun = true;

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
      lightdm = {
        greeters.enso = {
          enable = true;
          blur = true;
          # extraConfig = ''
          #   default-wallpaper=/usr/share/streets_of_gruvbox.png
          # '';
        };
      };
    };
  };
}
