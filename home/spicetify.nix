{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    spicetify-cli
  ];
  xdg.configFile."spicetify/config-xpui.ini".text = ''
    [Setting]
    spotify_launch_flags    =
    check_spicetify_upgrade = 0
    spotify_path            = ${pkgs.spotify}
    prefs_path              = $HOME/.config/spotify/prefs
    current_theme           = Ziro
    overwrite_assets        = 0
    color_scheme            = purple-dark
    inject_css              = 1
    replace_colors          = 1

    [Preprocesses]
    disable_ui_logging    = 1
    remove_rtl_rule       = 1
    expose_apis           = 1
    disable_upgrade_check = 1
    disable_sentry        = 1

    [AdditionalOptions]
    extensions            =
    custom_apps           =
    sidebar_config        = 1
    home_config           = 1
    experimental_features = 1

    [Patch]

    ; DO NOT CHANGE!
    [Backup]
    version =
    with    =
  '';
}
