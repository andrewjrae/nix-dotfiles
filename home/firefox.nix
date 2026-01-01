{ pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.ajrae = {
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
      search.force = true;

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
