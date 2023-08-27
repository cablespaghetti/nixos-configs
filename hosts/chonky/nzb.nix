{
  pkgs,
  lib,
  config,
  ...
}: {
  services.sabnzbd = {
    enable = true;
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "jellyfin";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "jellyfin";
  };
}
