{ config, pkgs, lib, ... }: {

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      system = aarch64-darwin # M1 gang
      extra-platforms = aarch64-darwin x86_64-darwin # But we use rosetta too
      experimental-features = nix-command flakes
      build-users-group = nixbld
    '';
    gc = {
      automatic = true;
      interval = { Day = 3; };
      options = "--delete-older-than 20d";
    };
  };
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira
      fira-code
      font-awesome_5
    ];
  };

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  users.users.ajrae = {
    home = "/Users/ajrae";
    packages = [ pkgs.skhd ];
  };
  networking.hostName = "tricouni";
  system.stateVersion = 4;

#  system.keyboard = {
#    enableKeyMapping = true;
#    remapCapsLockToEscape = true;
#  };
  system.defaults = {
    screencapture = { location = "/tmp"; };
    dock = {
      autohide = true;
      showhidden = true;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      FXEnableExtensionChangeWarning = true;
    };
#    NSGlobalDomain = {
#      AppleKeyboardUIMode = 3;
#      ApplePressAndHoldEnabled = false;
#      AppleFontSmoothing = 1;
#      _HIHideMenuBar = true;
#      InitialKeyRepeat = 10;
#      KeyRepeat = 1;
#      "com.apple.mouse.tapBehavior" = 1;
#      "com.apple.swipescrolldirection" = true;
#    };
  };
}
