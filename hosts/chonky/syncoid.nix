{
  pkgs,
  lib,
  config,
  ...
}: {
  services.syncoid = {
    enable = true;
    commonArgs = [
      "--no-sync-snap"
      "--sshoption=StrictHostKeyChecking=off"
    ];
    commands = {
      runningcafe-web1-postgres16 = {
        source = "root@runningcafe-web1:rpool/postgres16";
        target = "bigdata/runningcafe-web1/postgres16";
      };
      runningcafe-web1-redis-storage = {
        source = "root@runningcafe-web1:rpool/redis-storage";
        target = "bigdata/runningcafe-web1/redis-storage";
      };
    };
  };
}
