{ config, lib, pkgs, home-manager, inputs,... }:

let
  emacs-gui = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [
    epkgs.vterm
    epkgs.pdf-tools
    epkgs.org-pdftools
  ]));
  emacs-tui = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [
    epkgs.vterm
  ]));
in
{
  home.packages = with pkgs; [
    # doom dependencies
    git
    gnutls
    (ripgrep.override {withPCRE2 = true;})
    fd
    gnused

    # Install emacs externally so we can manage the dotfiles manually
    # (this makes tinkering and installing doom much easier)
    (if pkgs.stdenv.isDarwin
      then emacs-mac
      else emacs-tui)

    # :tools lookup & :lang org +roam
    sqlite

    # :lang (cc +lsp)
    ccls

    # :lang org
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        collection-latexextra
        fontawesome5
        roboto
        latexmk;
    })

    # :checkers spell
    (aspellWithDicts (ds: with ds; [
      en en-computers en-science
    ]))
  ];

 # services.emacs = {
 #   enable = true;
 #   package = emacs-src;
 #   defaultEditor = true;
 # };

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

#  programs.zsh.shellAliases = { ecli = "TERM=xterm-24bit emacsclient -t"; };

}
