{
  description = "Andrew's Nix Environment";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Nix-Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
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
    # hyprland!
    hyprland.url = "github:hyprwm/Hyprland";
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
     {
      darwinConfigurations = {
        "ajrae-mac" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/standard.nix
            inputs.home-manager.darwinModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/standard.nix
                  ];
                };
              };
              nixpkgs = {
                config.allowUnfree = true;
                overlays = [ inputs.emacs-overlay.overlay ];
              };
            }
          ];
        };
        "ajrae-mac-twm" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/standard.nix
            ./darwin/twm.nix
            inputs.home-manager.darwinModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/standard.nix
                  ];
                };
              };
              nixpkgs = {
                config.allowUnfree = true;
                overlays = [
                  inputs.emacs-overlay.overlay
                  inputs.spacebar.overlay
                ];
              };
            }
          ];
        };
      };

      nixosConfigurations = {
        "garibaldi" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/garibaldi
            # ./nixos/xmonad.nix
            ./nixos/hyprland.nix
            inputs.hyprland.nixosModules.default
            inputs.nixos-hardware.nixosModules.dell-xps-15-9560-intel
            inputs.home-manager.nixosModule
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/standard.nix
                    # ./home/xmonad.nix
                    ./home/hyprland.nix
                    inputs.hyprland.homeManagerModules.default
                    ({home-manager,...}: { services.emacs.enable = true; })
                  ];
                };
              };
              nixpkgs = {
                config.allowUnfree = true;
                overlays = [
                  inputs.emacs-overlay.overlay
                  inputs.eww.overlays.default
                  inputs.rust-overlay.overlays.default
                ];
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        "andrewr-dev" = let
          system = "x86_64-linux";
        in inputs.home-manager.lib.homeManagerConfiguration rec {
          modules = [
            ./home/users/andrewr
            ./modules/common.nix
            ./modules/zsh.nix
            ./modules/emacs.nix
            ({config,...}: { isServer = true; })
          ];
          pkgs = import nixpkgs {
            overlays = [ inputs.emacs-overlay.overlay ];
            inherit system;
          };
        };
      };
    };
}
