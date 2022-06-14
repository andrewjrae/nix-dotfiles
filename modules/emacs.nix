{ config, lib, pkgs, ... }:

{
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];
  home.packages = with pkgs; [
    # doom dependencies
    git
    gnutls
    ripgrep

    # Install emacs externally so we can manager the dotfiles manually
    # (this makes tinkering much easier)
    ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
    ]))

    # :tools lookup & :lang org +roam
    sqlite

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
}
