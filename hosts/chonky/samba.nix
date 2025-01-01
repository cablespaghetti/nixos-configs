{
  pkgs,
  lib,
  config,
  ...
}: {
  services.samba-wsdd = {
    # make shares visible for windows 10 clients
    enable = true;
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "invalid users" = [
          "root"
        ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
        workgroup = "WORKGROUP";
        "server string" = "chonky";
        "netbios name" = "chonky";
        "hosts allow" = ["192.168.42." "127.0.0.1" "localhost"];
        "hosts deny" = ["0.0.0.0/0" "::/0"];
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      video = {
        path = "/data/video";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "sam";
        "force group" = "users";
      };
    };
  };
  networking.firewall.allowPing = true;
}
