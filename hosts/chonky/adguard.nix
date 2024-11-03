{
  pkgs,
  lib,
  config,
  ...
}: {
  services.adguardhome = {
    enable = true;
    settings = {
      dns = {
        bind_hosts = ["192.168.42.121"];
        upstream_dns = [
          "9.9.9.9"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = true;
        safe_search = {
          enabled = true;
        };
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
        }
        {
          enabled = true;
          url = "https://nsfw.oisd.nl";
        }
        {
          enabled = true;
          url = "https://big.oisd.nl";
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/gambling.txt";
        }
      ];
    };
  };
}
