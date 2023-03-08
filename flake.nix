{
  description = "Andrew's Nix Environment";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/master";
    # Nix-Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      # url = "github:supermarin/nix-darwin/applications-collision";
      inputs.nixpkgs.follows = "unstable";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    # Bar (macos)
    spacebar = {
      url = "github:shaunsingh/spacebar";
      inputs.nixpkgs.follows = "unstable";
    };
    # Emacs overlay
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    with inputs; {
      darwinConfigurations."ajrae-mac" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/mac.nix
          home-manager.darwinModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ajrae = {
                imports = [
                  ./users/ajrae/home.nix
                  ./modules/general.nix
                  ./modules/zsh.nix
                  ./modules/fonts.nix
                  ./modules/emacs.nix
                  ./modules/alacritty.nix
                ];
              };
            };
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [ emacs-overlay.overlay ];
            };
          }
        ];
      };
      darwinConfigurations."ajrae-mac-twm" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/mac.nix
          ./modules/twm.nix
          home-manager.darwinModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ajrae = {
                imports = [
                  ./users/ajrae/home.nix
                  ./modules/general.nix
                  ./modules/pass.nix
                  ./modules/zsh.nix
                  ./modules/fonts.nix
                  ./modules/emacs.nix
                  ./modules/alacritty.nix
                ];
              };
            };
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [
                emacs-overlay.overlay
                spacebar.overlay
              ];
            };
          }
        ];
      };
      homeConfigurations."andrewr-dev" = let
        system = "x86_64-linux";
      in home-manager.lib.homeManagerConfiguration rec {
        modules = [
          ./users/andrewr/home.nix
          ./modules/general.nix
          ./modules/zsh.nix
          ./modules/emacs.nix
          ({config,...}: { isServer = true; })
        ];
        pkgs = import nixpkgs {
          overlays = [ emacs-overlay.overlay ];
          inherit system;
        };
      };
    };
}
