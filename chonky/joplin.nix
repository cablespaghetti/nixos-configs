{
  config,
  pkgs,
  ...
}: {
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
  # Greatly inspired by https://github.com/burmudar/dotfiles/blob/0d2ee4a9d2af95b3fe76c88cd34c16077ea044bb/nix/hosts/media/configuration.nix#L145
  # Needed because we're using a custom caddy package
  config.systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
  config.services.caddy = {
    enable = true;
    package = pkgs.cloudflare-caddy;
    virtualHosts."chonky.buffalo-squeaker.ts.net".extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
  };
  config.services.tailscale = {
    permitCertUid = "caddy";
  };
}
