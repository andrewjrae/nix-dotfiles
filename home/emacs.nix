{ config, lib, pkgs, home-manager, inputs,... }:

let
  #emacs-gui = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [
  emacs-gui = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [
    epkgs.vterm
    epkgs.pdf-tools
    epkgs.org-pdftools
  ]));
  emacs-tui = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]));
  emacs-mac = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [
    epkgs.vterm
    epkgs.pdf-tools
    epkgs.org-pdftools
  ]));
  emacs-in-use = (if config.isServer
                  then emacs-tui
                  else (if pkgs.stdenv.isDarwin
                        then emacs-mac
                        else emacs-gui));
in
{
  home.packages = with pkgs; [
    # doom dependencies
    git
    gnutls
    (ripgrep.override {withPCRE2 = true;})
    fd
    gnused
    emacs-all-the-icons-fonts

    # Install doom emacs externally so we can manage the dotfiles manually
    # (this makes tinkering and installing doom much easier)
    emacs-in-use

    # :tools lookup & :lang org +roam
    sqlite

    # :lang (cc +lsp)
    ccls
    #clang-tools

    # :lang (rust +lsp)
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy

    # :checkers spell
    (aspellWithDicts (ds: with ds; [
      en en-computers en-science
    ]))
  ]
  ++
  # :lang org
  (if config.isServer then
    []
   else
     [(texlive.combine {
       inherit (texlive)
         scheme-medium
         collection-latexextra
         fontawesome5
         roboto
         latexmk;})
      pandoc]
  );

  services.emacs = {
    enable = lib.mkDefault false;
    package = emacs-in-use;
    defaultEditor = true;
  };

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];
}
