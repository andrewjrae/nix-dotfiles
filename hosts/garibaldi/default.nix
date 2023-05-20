# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelParams = ["acpi_rev_override=1"];
  boot.kernelModules = ["acpi_call"];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 7;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    # automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 20d";
    };
  };

  networking.hostName = "garibaldi";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
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
    desktopManager.wallpaper.mode = "fill";
  };

  hardware.opengl.enable = true; # the rest of opengl config comes from nixos-hardware

  hardware.bluetooth = {
    enable = true;
    # battery info support
    package = pkgs.bluez5-experimental;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ajrae = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      # TODO: migrate keys to here
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # home manager does the rest, but this is needed for everything to work
  programs.zsh.enable = true;

  # allows for gtk themeing from home-manager
  programs.dconf.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
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
    powertop
  ];

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable upower
  services.upower.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
