{
  pkgs,
  lib,
  config,
  ...
}: {
  services.sabnzbd = {
    enable = true;
    configFile = "/var/lib/sabnzbd/sabnzbd-sam.ini";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "jellyfin";
  };
}
