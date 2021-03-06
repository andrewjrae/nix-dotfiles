{ config, lib, pkgs, ... }:

let emacs = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
      epkgs.org-pdftools
    ]));
in
{
  home.packages = with pkgs; [
    # doom dependencies
    git
    gnutls
    ripgrep

    # Install emacs externally so we can manage the dotfiles manually
    # (this makes tinkering and installing doom much easier)
    emacs

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

  services.emacs = {
    enable = true;
    package = emacs;
    defaultEditor = true;
  };

  home.sessionPath = [ "$HOME/.emacs.d/bin" ];

  programs.zsh.shellAliases = { ecli = "TERM=xterm-direct emacsclient -t"; };

}
