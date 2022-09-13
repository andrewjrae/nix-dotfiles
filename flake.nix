{
  description = "Andrew's Nix Environment";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/master";
    # All packages should follow latest nixpkgs/nur (TODO: figure out what this is)
    #nur.url = "github:nix-community/NUR";
    # Nix-Darwin
    darwin = {
      #url = "github:LnL7/nix-darwin";
      url = "github:supermarin/nix-darwin/applications-collision";
      inputs.nixpkgs.follows = "unstable";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      #url = "github:nix-community/home-manager";
      url = "github:supermarin/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    # Bar (macos)
    spacebar = {
      url = "github:shaunsingh/spacebar";
      inputs.nixpkgs.follows = "unstable";
    };
    # WM
    yabai-src = {
      url = "github:koekeishiya/yabai";
      flake = false;
    };
    # Emacs overlay
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    # SRC for macOS emacs overlay
    emacs-src = {
      url = "github:emacs-mirror/emacs";
      flake = false;
    };
    # Use latest libverm to build macOS emacs build
    emacs-vterm-src = {
      url = "github:akermu/emacs-libvterm";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    with inputs; let
      yabai-overlay = final: prev: {
        yabai =
          let
            version = "4.0.0-dev";
            buildSymlinks = prev.runCommand "build-symlinks" { } ''
                       mkdir -p $out/bin
                       ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
                     '';
          in
            prev.yabai.overrideAttrs (old: {
              inherit version;
              src = inputs.yabai-src;

              buildInputs = with prev.darwin.apple_sdk.frameworks; [
                Carbon
                Cocoa
                ScriptingBridge
                prev.xxd
                SkyLight
              ];

              nativeBuildInputs = [ buildSymlinks ];
            });
      };
      emacs-mac-overlay = (final: prev: {
        emacs-vterm = prev.stdenv.mkDerivation rec {
          pname = "emacs-vterm";
          version = "master";

          src = inputs.emacs-vterm-src;

          nativeBuildInputs = [ prev.cmake prev.libtool prev.glib.dev ];

          buildInputs =
            [ prev.glib.out prev.libvterm-neovim prev.ncurses ];

          cmakeFlags = [ "-DUSE_SYSTEM_LIBVTERM=yes" ];

          preConfigure = ''
                      echo "include_directories(\"${prev.glib.out}/lib/glib-2.0/include\")" >> CMakeLists.txt
                      echo "include_directories(\"${prev.glib.dev}/include/glib-2.0\")" >> CMakeLists.txt
                      echo "include_directories(\"${prev.ncurses.dev}/include\")" >> CMakeLists.txt
                      echo "include_directories(\"${prev.libvterm-neovim}/include\")" >> CMakeLists.txt
                    '';

          installPhase = ''
                      mkdir -p $out
                      cp ../vterm-module.so $out
                      cp ../vterm.el $out
                    '';

        };
        emacs-mac = (prev.emacs.override {
          srcRepo = true;
          nativeComp = true;
          withSQLite3 = true;
          withXwidgets = false;
        }).overrideAttrs (o: rec {
          version = "29.0.50";
          src = inputs.emacs-src;

          buildInputs = o.buildInputs
                        ++ [ prev.darwin.apple_sdk.frameworks.WebKit ];

          configureFlags = o.configureFlags ++ [
            "--without-gpm"
            "--without-dbus"
            "--without-mailutils"
            "--without-pop"
          ];

          patches = [
            ./patches/fix-window-role.patch
            ./patches/system-appearance.patch
          ];

          postPatch = o.postPatch + ''
                      substituteInPlace lisp/loadup.el \
                      --replace '(emacs-repository-get-branch)' '"master"'
                    '';

          postInstall = o.postInstall + ''
                      cp ${final.emacs-vterm}/vterm.el $out/share/emacs/site-lisp/vterm.el
                      cp ${final.emacs-vterm}/vterm-module.so $out/share/emacs/site-lisp/vterm-module.so
                    '';

          CFLAGS =
            "-DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -g -O3 -mtune=native -march=native -fomit-frame-pointer";
        });
      });
    in {
      darwinConfigurations."ajrae-laptop" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/mac.nix
          #./modules/pam.nix
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
              overlays = [ emacs-mac-overlay ];
            };
          }
        ];
      };
      darwinConfigurations."ajrae-laptop-twm" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./modules/mac.nix
          ./modules/twm.nix
          #./modules/pam.nix
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
              overlays = [
                #nur.overlay
                emacs-mac-overlay
                yabai-overlay
                spacebar.overlay
              ];
            };
          }
        ];
      };
      homeManagerConfigurations."andrewr-dev" = let
        system = "86_64-linux";
      in home-manager.lib.homeManagerConfiguration rec {
        modules = [
          ./users/andrewr/home.nix
          ./modules/general.nix
          ./modules/zsh.nix
          ./modules/emacs.nix
        ];
        pkgs = import nixpkgs {
          overlays = [ emacs-overlay.overlay ];
          inherit system;
        };
      };
    };
}
