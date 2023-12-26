{
  pkgs,
  lib,
  config,
  ...
}: {
  services.transmission = {
    enable = true;
    openFirewall = true;
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;
      watch-dir-enabled = true;
      watch-dir = "/data/video/torrents/watch";
      trash-original-torrent-files = true;
      incomplete-dir = "/data/video/torrents/incomplete";
      download-dir = "/data/video/torrents/complete";
      speed-limit-up-enabled = true;
      speed-limit-down-enabled = true;
      speed-limit-up = 2500;
      speed-limit-down = 20000;
      port-forwarding-enabled = false;
      download-queue-enabled = false;
    };
    performanceNetParameters = true;
  };
}
