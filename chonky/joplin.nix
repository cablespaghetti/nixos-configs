{config, ...}: {
  config.virtualisation.oci-containers.containers = {
    joplin = {
      image = "docker.io/joplin/server:2.12.1-beta";
      ports = ["127.0.0.1:22300:22300"];
      volumes = [
        "/data/joplin:/data"
      ];
      environment = {
        APP_BASE_URL = "https://joplin.weston.world";
        STORAGE_DRIVER = "Type=Filesystem; Path=/data";
        SQLITE_DATABASE = "/data/db.sqlite";
      };
    };
  };
}
