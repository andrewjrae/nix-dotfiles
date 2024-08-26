# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
      ../../nixos/common.nix
    ];

  networking.hostName = "jukebox";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # hardware.bluetooth = {
  #   enable = true;
  #   # battery info support
  #   package = pkgs.bluez5-experimental;
  # };

  # Auto mount usb devices
  services.devmon.enable = true;
  services.gvfs.enable = true;

  users.users.ajrae = {
    password = "ajrae"; # dummy password
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+7lhJEotTme2xeF6mrjjNO+QorIkPxYz4lOB648fDy ajrae@garibaldi"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # home manager does the rest, but this is needed for everything to work
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  # Enable avahi for mDNS lookup
  # (otherwise can't ssh to hostname with my current router)
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    killall
  ];

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.01"; # Did you read the comment?

}
