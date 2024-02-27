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
    ];
    user = "root";
    commands = {
      runningcafe-web1 = {
        source = "root@runningcafe-web1:rpool/postgres16";
        target = "bigdata/runningcafe-web1/postgres16";
      };
    };
  };
}
