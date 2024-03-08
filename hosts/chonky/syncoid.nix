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
      runningcafe-web1-object-storage = {
        source = "root@runningcafe-web1:rpool/object-storage";
        target = "bigdata/runningcafe-web1/object-storage";
      };
      runningcafe-web2-tonywinn-wordpress-database = {
        source = "root@runningcafe-web2:rpool/tonywinn-wordpress-database";
        target = "bigdata/runningcafe-web2/tonywinn-wordpress-database";
      };
      runningcafe-web2-tonywinn-wordpress-html = {
        source = "root@runningcafe-web2:rpool/tonywinn-wordpress-html";
        target = "bigdata/runningcafe-web2/tonywinn-wordpress-html";
      };
    };
  };
}
