{ config, lib, pkgs, inputs,... }:

let
  channelsPath = "channels/nixpkgs";
in
{
  # add any global options we want here
  options = with lib; with types; {
    wmCmd = mkOption {
      type = str;
      default = "startx";
    };
  };

  config = {
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
      nixPath = [ "nixpkgs=/etc/${channelsPath}" ];
    };
    environment.etc."${channelsPath}".source = inputs.nixpkgs.outPath;

    fonts.fontconfig.defaultFonts = {
      sansSerif = [ "Fira" ];
      monospace = [ "Fira Code" ];
    };

    # docker
    virtualisation.docker.enable = true;

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.enableAllTerminfo = true;
    # default packages
    environment.systemPackages = with pkgs; [
      killall
      ddcutil
    ];

    environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

    # allows for gtk themeing from home-manager
    programs.dconf.enable = true;

    # home manager does the rest, but this is needed for everything to work
    programs.zsh.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    programs.ssh.startAgent = true;
    # open up ssh port
    networking.firewall.allowedTCPPorts = [ 22 ];

    # Enable avahi for mDNS lookup
    # (otherwise can't ssh to hostname with my current router)
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ajrae = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" "video"];
      openssh.authorizedKeys.keys = [
        # TODO: migrate keys to here
      ];
      shell = pkgs.zsh;
    };

    # Auto mount usb devices
    services.devmon.enable = true;
    services.gvfs.enable = true;

    hardware.bluetooth = {
      enable = true;
      # battery info support
      package = pkgs.bluez;
    };

    hardware.graphics.enable = true;

    # Set your time zone.
    time.timeZone = "America/Vancouver";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_CA.UTF-8";

    # Enable networking
    networking.networkmanager.enable = true;

    boot.supportedFilesystems = ["ntfs"];

    # for ddcci back light control
    # boot.kernelModules = [ "i2c-dev" "ddcci_backlight" ];
    # hardware.i2c.enable = true;
    # boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    services.ddccontrol.enable = true;


    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    nix.settings.extra-platforms = ["aarch64-linux"];

  };
}
