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
    environment.etc."${channelsPath}".source = inputs.unstable.outPath;
  };
}
