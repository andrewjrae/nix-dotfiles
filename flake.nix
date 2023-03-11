{
  description = "Andrew's Nix Environment";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/master";
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
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    with inputs; {
      darwinConfigurations = {
        "ajrae-mac" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/standard.nix
            home-manager.darwinModule
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
                overlays = [ emacs-overlay.overlay ];
              };
            }
          ];
        };
        "ajrae-mac-twm" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/standard.nix
            ./darwin/twm.nix
            home-manager.darwinModule
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
                  emacs-overlay.overlay
                  spacebar.overlay
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
            home-manager.nixosModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ajrae = {
                  imports = [
                    ./home/users/ajrae
                    ./home/standard.nix
                    ({home-manager,...}: { services.emacs.enable = true; })
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
      };

      homeConfigurations = {
        "andrewr-dev" = let
          system = "x86_64-linux";
        in home-manager.lib.homeManagerConfiguration rec {
          modules = [
            ./home/users/andrewr
            ./modules/common.nix
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
    };
}
