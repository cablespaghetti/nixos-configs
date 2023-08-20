{
  docker-compose.volumes = {
    "joplin-data" = {driver = "zfs";};
  };
  project.name = "joplin";
  services = {
    joplin = {
      service = {
        image = "docker.io/joplin/server:2";
        ports = [
          22300
        ];
        environment = {
          APP_BASE_URL = "https://joplin.weston.world";
          STORAGE_DRIVER = "Type=Filesystem; Path=/data";
          SQLITE_DATABASE = "/data/db.sqlite";
        };
        volumes = [
          "joplin-data:/data"
        ];
        restart = "unless-stopped";
      };
    };
  };
}
