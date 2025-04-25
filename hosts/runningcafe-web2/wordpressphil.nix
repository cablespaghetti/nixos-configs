{
  config,
  pkgs,
  ...
}: let
  philbdrumsNginxConfig = pkgs.writeTextFile {
    name = "philbdrumsNginxConfig";
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
            fastcgi_pass   philbdrums-wordpress:9000;
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
  config.virtualisation.oci-containers.containers = {
    philbdrums-db = {
      image = "docker.io/library/mariadb:11";
      ports = ["127.0.0.1:3306:3307"];
      environment = {
        MARIADB_DATABASE = "philbdrums";
        MARIADB_USER = "philbdrums";
      };
      volumes = [
        "philbdrums-wordpress-database:/var/lib/mysql"
      ];
    };
    philbdrums-wordpress = {
      image = "docker.io/library/wordpress:6-php8.2-fpm-alpine";
      dependsOn = ["philbdrums-db"];
      ports = ["9000"];
      volumes = [
        "philbdrums-wordpress-html:/var/www/html"
      ];
    };
    philbdrums-nginx = {
      image = "docker.io/library/nginx:1.26-alpine";
      dependsOn = ["philbdrums-wordpress"];
      ports = ["127.0.0.1:8081:80"];
      volumes = [
        "philbdrums-wordpress-html:/var/www/html"
        "${philbdrumsNginxConfig}:/etc/nginx/conf.d/default.conf"
      ];
    };
  };
  config.services.caddy = {
    virtualHosts."beta.philbdrums.co.uk".extraConfig = ''
      reverse_proxy http://127.0.0.1:8081
    '';
  };
}
