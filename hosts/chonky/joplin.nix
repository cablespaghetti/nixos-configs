{
  config,
  pkgs,
  ...
}: {
  config.virtualisation.oci-containers.containers = {
    joplin = {
      image = "docker.io/joplin/server:2.14-beta";
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
  # Greatly inspired by https://github.com/burmudar/dotfiles/blob/0d2ee4a9d2af95b3fe76c88cd34c16077ea044bb/nix/hosts/media/configuration.nix#L145
  # Needed because we're using a custom caddy package
  config.systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
  config.age.secrets.caddy-cloudflare = {
    file = ../../secrets/caddy-cloudflare.age;
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };
  config.systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy-cloudflare.path;
  config.services.caddy = {
    enable = true;
    package = pkgs.cloudflare-caddy;
    email = "sam@weston.world";
    logFormat = ''
      level INFO
    '';
    virtualHosts."http://192.168.42.222".extraConfig = ''
      root * /srv/tftp
      file_server browse
    '';
    virtualHosts."joplin.weston.world".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_TOKEN}
        resolvers 1.1.1.1
      }
      reverse_proxy http://127.0.0.1:22300
    '';
    virtualHosts."chonky.buffalo-squeaker.ts.net".extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
      tls {
        get_certificate tailscale
      }
    '';
  };
  config.services.tailscale = {
    permitCertUid = "caddy";
  };
  config.services.restic.backups.b2.paths = [
    "/data/joplin"
  ];
}
