# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  modules,
  ...
}: {
  networking.hostName = "runningcafe-web2";
  networking.firewall = {
    allowedUDPPorts = [config.services.tailscale.port];
    allowedTCPPorts = [443 80 9200];
  };
  services.openssh.openFirewall = true;
  documentation.enable = false;
  environment.noXlibs = true;

  # ZFS things
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
  environment.systemPackages = with pkgs; [
    lzop
    mbuffer
    hdparm
    python3
    python311Packages.pip
    pipenv
  ];

  # Set up zed for ZFS notification emails
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = ["root"];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  # this option does not work; will return error
  services.zfs.zed.enableMail = false;

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    daemon = {
      settings = {
        ipv6 = true;
        fixed-cidr-v6 = "fd00:1::/64";
        experimental = true;
        ip6tables = true;
        metrics-addr = "127.0.0.1:9323";
      };
    };
  };
  users.users.sam.extraGroups = ["docker"];
  services.prometheus.exporters.zfs = {
    enable = true;
    extraFlags = [
      "--no-collector.dataset-filesystem"
      "--no-collector.dataset-volume"
      "--web.disable-exporter-metrics"
    ];
  };
  services.grafana-agent = {
    settings = {
      metrics = {
        configs = [
          {
            name = "docker";
            scrape_configs = [
              {
                job_name = "runningcafe-web2-docker";
                static_configs = [
                  {targets = ["localhost:9323"];}
                ];
              }
              #{
              #  job_name = "runningcafe-web2-keithbot";
              #  static_configs = [
              #    {targets = ["localhost:10000"];}
              #  ];
              #}
            ];
          }
          {
            name = "zfs";
            scrape_configs = [
              {
                job_name = "runningcafe-web2-zfs";
                static_configs = [
                  {targets = ["localhost:9134"];}
                ];
              }
            ];
          }
        ];
      };
    };
  };

  # Backups are good
  services.sanoid = {
    enable = true;
    interval = "*-*-* 02:50:00";
    templates = {
      daily = {
        autoprune = true;
        autosnap = true;
        daily = 90;
        monthly = 6;
      };
    };
    datasets = {
      "rpool/tonywinn-wordpress-database" = {
        useTemplate = ["daily"];
      };
      "rpool/tonywinn-wordpress-html" = {
        useTemplate = ["daily"];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
