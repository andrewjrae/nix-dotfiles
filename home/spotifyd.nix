{ config, lib, pkgs, ... }:

{
    services.spotifyd = {
        enable = true;
        settings = {
            global = {
                zeroconf_port = 4444;
                autoplay = false;
                bitrate = 320;
                device_name = "Boppity Beans";
                device_type = "speaker";
                device = "sysdefault:CARD=D10s";
                backend = "alsa";
            };
        };
    };
}
