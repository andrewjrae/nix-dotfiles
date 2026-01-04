{ pkgs, inputs, ... }:

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
      };

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        darkreader
        tridactyl
      ];
    };
  };
}
