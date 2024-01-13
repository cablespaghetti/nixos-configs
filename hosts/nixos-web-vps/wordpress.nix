{
  config,
  pkgs,
  ...
}: let
  tonywinnNginxConfig = pkgs.writeTextFile {
    name = "tonywinnNginxConfig";
    text = ''
      server {
        listen       80;
        server_name  localhost;
        root   /var/www/html;

        location / {
            index  index.php;
            try_files $uri $uri/ /index.php?$args;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }

        # pass the PHP scripts to FastCGI server listening on port 9000
        #
        location ~ \.php$ {
            #root           html;
            fastcgi_pass   tonywinn-wordpress:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /var/www/html/$fastcgi_script_name;
            include        fastcgi_params;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
            expires max;
        }

        location = /robots.txt {
            allow all;
        }

        # Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
        # Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
        location ~ /\. {
            deny all;
        }

        # Deny access to any files with a .php extension in the uploads directory
        # Works in sub-directory installs and also in multisite network
        # Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
        location ~* /(?:uploads|files)/.*\.php$ {
            deny all;
        }
      }
    '';
  };
in {
  config.virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  config.age.secrets.tonywinn-wordpress = {
    file = ../../secrets/tonywinn-wordpress.age;
  };
  config.networking.firewall.interfaces."podman0" = {
    allowedUDPPorts = [53];
    allowedTCPPorts = [53];
  };
  config.virtualisation.oci-containers.containers = {
    tonywinn-db = {
      image = "docker.io/library/mariadb:11";
      ports = ["127.0.0.1:3306:3306"];
      environment = {
        MARIADB_DATABASE = "tonywinn";
        MARIADB_USER = "tonywinn";
      };
      environmentFiles = [
        config.age.secrets.tonywinn-wordpress.path
      ];
      volumes = [
        "tonywinn-wordpress-database:/var/lib/mysql"
      ];
    };
    tonywinn-wordpress = {
      image = "docker.io/library/wordpress:6-php7.4-fpm-alpine";
      dependsOn = ["tonywinn-db"];
      ports = ["9000"];
      volumes = [
        "tonywinn-wordpress-html:/var/www/html"
      ];
    };
    tonywinn-nginx = {
      image = "docker.io/library/nginx:1.22-alpine";
      dependsOn = ["tonywinn-wordpress"];
      ports = ["127.0.0.1:8080:80"];
      volumes = [
        "tonywinn-wordpress-html:/var/www/html"
        "${tonywinnNginxConfig}:/etc/nginx/conf.d/default.conf"
      ];
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
    virtualHosts."www.tonywinn.org.uk".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_TOKEN}
        resolvers 1.1.1.1
      }
      redir https://tonywinn.org.uk
    '';
    virtualHosts."tonywinn.org.uk".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_TOKEN}
        resolvers 1.1.1.1
      }
      reverse_proxy http://127.0.0.1:8080
    '';
  };
  config.services.restic.backups.b2.paths = [
    "/var/lib/containers/storage/volumes/tonywinn-wordpress-database"
    "/var/lib/containers/storage/volumes/tonywinn-wordpress-html"
  ];
}
