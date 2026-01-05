{ pkgs, inputs, ... }:

let
  ff-ext-pkgs = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.tridactyl-native
    ];

    profiles.ajrae = {
      settings = {
        "dom.security.https_only_mode" = true;
        "network.prefetch-next" = false;
        "privacy.query_stripping.enabled.pbmode" = true;
        "toolkit.telemetry.enabled" = false;
        "browser.search.geoip.url" = "";
        "network.cookie.cookieBehavior" = 4;
        "browser.urlbar.quicksuggest.migrationVersion" = 6;
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
      };

      extensions.packages = with ff-ext-pkgs; [
        ublock-origin
        darkreader
        tridactyl
      ];
    };
  };

  xdg.configFile.tridactyl.source = ../configs/tridactyl;
}
