{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    pass = {
      enable = true;
      stores = [ "$HOME/.password-store" ];
    };
    # ported theme from rasi config
    theme = let
      # Use `mkLiteral` for string-like values that should show without
      # quotes, e.g.:
      # {
      #   foo = "abc"; => foo: "abc";
      #   bar = mkLiteral "abc"; => bar: abc;
      # };
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "#282c34";
        border-color = mkLiteral "#282c34";
        text-color = mkLiteral "#bbc2cf";
        font = "Fira Sans Mono 11";
        prompt-font = "Fira Sans Mono 11";
        prompt-background = mkLiteral "#98be65";
        prompt-foreground = mkLiteral "#282c34";
        prompt-padding = mkLiteral "4px";
        alternate-normal-background = mkLiteral "#1c1f24";
        alternate-normal-foreground = mkLiteral "@text-color";
        selected-normal-background = mkLiteral "#51afef";
        selected-normal-foreground = mkLiteral "#ffffff";
        spacing = 3;
      };
      "window" = {
        border = 2;
        border-color = mkLiteral "#5e81ac";
        padding = 5;
      };
      "mainbox" = {
        border = 1;
        padding = 0;
      };
      "message" = {
        border = mkLiteral "1px dash 0px 0px ";
        padding = mkLiteral "1px ";
      };
      "listview" = {
        fixed-height = 0;
        border = mkLiteral "2px dash 0px 0px ";
        spacing = mkLiteral "2px ";
        scrollbar = true;
        padding = mkLiteral "2px 0px 0px ";
      };
      "element" = {
        children = mkLiteral "[element-icon, element-text]";
        border = 0;
        padding = mkLiteral "1px ";
      };
      "element.selected.normal" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = mkLiteral "@selected-normal-foreground";
      };
      "element.alternate.normal" = {
        background-color = mkLiteral "@alternate-normal-background";
        text-color = mkLiteral "@alternate-normal-foreground";
      };
      "scrollbar" = {
        width = mkLiteral "0px ";
        border = 0;
        handle-width = mkLiteral "0px ";
        padding = 0;
      };
      "sidebar" = {
        border = mkLiteral "2px dash 0px 0px ";
      };
      "button.selected" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = mkLiteral "@selected-normal-foreground";
      };
      "inputbar" = {
        spacing = 0;
        padding = mkLiteral "1px ";
      };
      "case-indicator" = {
        spacing = 0;
      };
      "entry" = {
        padding = mkLiteral "4px 4px";
        expand = false;
        width = mkLiteral "10em";
      };
      "prompt" = {
        padding = mkLiteral "@prompt-padding";
        background-color = mkLiteral "@prompt-background";
        text-color = mkLiteral "@prompt-foreground";
        font = mkLiteral "@prompt-font";
        border-radius = mkLiteral "1px";
      };
      "element-text" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "element-icon" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
    };
  };
}
