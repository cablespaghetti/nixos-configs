{
  services.postgres = {
    service.image = "docker.io/library/postgres:10";
    #service.volumes = [ "${toString ./.}/postgres-data:/var/lib/postgresql/data" ];
    service.environment.POSTGRES_PASSWORD = "mydefaultpass";
  };
}
