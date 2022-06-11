{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # doom dependencies
    git
    gnutls
    ripgrep

    # Install emacs externally so we can manager the dotfiles manually
    # (this makes tinkering much easier)
    ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]))

    # :lang org
    texlive.combined.scheme-medium

    # :checkers spell
    (aspellWithDicts (ds: with ds; [
      en en-computers en-science
    ]))
  ];
}
