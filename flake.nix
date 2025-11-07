{
  description = "Andrew's Nix Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Nix-Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Bar (macos)
    spacebar = {
      url = "github:shaunsingh/spacebar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Emacs overlay
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland!
    hyprland.url = "github:hyprwm/Hyprland/v0.47.2";
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
     rec {
      darwinConfigurations = {
        "ajrae-mac-aero" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/standard.nix
            ./darwin/twm-aero.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/standard.nix
                    ./home/darwin.nix
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
          specialArgs = { inherit inputs; };
        };
        "ajrae-mac-twm" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/standard.nix
            ./darwin/twm.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/standard.nix
                    ./home/darwin.nix
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
          specialArgs = { inherit inputs; };
        };
      };

      nixosConfigurations = {
        "garibaldi" = nixpkgs.lib.nixosSystem rec {
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
                extraSpecialArgs = { inherit inputs; emacs-overlay-packages = inputs.emacs-overlay.packages."${system}"; };
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

        "jukebox" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./hosts/jukebox
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
            inputs.home-manager.nixosModule
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/common.nix
                    ./home/zsh.nix
                    ./home/spotifyd.nix
                  ];
                };
              };
              nixpkgs = {
                config.allowUnfree = true;
                # Overlay to workaround kernel build issue:
                # https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
                overlays = [
                  (final: super: {
                    makeModulesClosure = x:
                      super.makeModulesClosure (x // { allowMissing = true; });
                  })
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
            ./home/common.nix
            ./home/zsh.nix
            ./home/emacs.nix
            ({config,...}: { isServer = true; })
          ];
          pkgs = import nixpkgs {
            overlays = [ inputs.emacs-overlay.overlay ];
            inherit system;
          };
        };
      };
      images.jukebox = nixosConfigurations.jukebox.config.system.build.sdImage;
    };
}
