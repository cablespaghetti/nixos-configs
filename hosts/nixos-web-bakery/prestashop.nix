{
  config,
  pkgs,
  ...
}: {
  config.virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  config.age.secrets.hayleysbakery-database = {
    file = ../../secrets/hayleysbakery-database.age;
  };
  config.networking.firewall.interfaces."podman0" = {
    allowedUDPPorts = [53];
    allowedTCPPorts = [53];
  };
  config.virtualisation.oci-containers.containers = {
    hayleysbakery-database = {
      image = "docker.io/library/mariadb:11";
      ports = ["127.0.0.1:3306:3306"];
      environment = {
        MARIADB_DATABASE = "hayleysbakery";
        MARIADB_USER = "hayleysbakery";
      };
      environmentFiles = [
        config.age.secrets.hayleysbakery-database.path
      ];
      volumes = [
        "hayleysbakery-database:/var/lib/mysql"
      ];
    };
    hayleysbakery-prestashop = {
      image = "docker.io/prestashop/prestashop:8.1";
      dependsOn = ["hayleysbakery-database"];
      ports = ["8080:80"];
      environment = {
      DB_SERVER = "hayleysbakery-database";
      DB_NAME = "hayleysbakery";
      DB_USER = "hayleysbakery";
      PS_DOMAIN = "hayleysbakery.com";
      };
      environmentFiles = [
        config.age.secrets.hayleysbakery-database.path
      ];
      volumes = [
        "hayleysbakery-prestashop:/var/www/html"
      ];
    };
  };
  # Greatly inspired by https://github.com/burmudar/dotfiles/blob/0d2ee4a9d2af95b3fe76c88cd34c16077ea044bb/nix/hosts/media/configuration.nix#L145
  # Needed because we're using a custom caddy package
  config.systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
#  config.age.secrets.caddy-cloudflare = {
#    file = ../../secrets/caddy-cloudflare.age;
#    owner = config.services.caddy.user;
#    group = config.services.caddy.group;
#  };
#  config.systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy-cloudflare.path;
  config.services.caddy = {
    enable = true;
    package = pkgs.cloudflare-caddy;
    email = "sam@weston.world";
    virtualHosts."www.hayleysbakery.com".extraConfig = ''
      tls self_signed
      redir https://hayleysbakery.com
    '';
    virtualHosts."hayleysbakery.com".extraConfig = ''
      tls self_signed
      reverse_proxy http://127.0.0.1:8080
    '';
  };
  config.services.restic.backups.b2.paths = [
    "/var/lib/containers/storage/volumes/hayleysbakery-database"
    "/var/lib/containers/storage/volumes/hayleysbakery-prestashop"
  ];
}
