{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [recyclarr];

  services.sabnzbd = {
    enable = true;
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
  };
}
