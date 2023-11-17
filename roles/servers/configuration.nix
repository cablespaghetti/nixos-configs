# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  modules,
  inputs,
  ...
}: {
  config = {
    # Set your time zone.
    time.timeZone = "Etc/UTC";

    # Disable IPv6 Privacy Extensions
    networking.tempAddresses = "disabled";
    networking.useNetworkd = true;

    # Define a user account. Don't forgeddt to set a password with ‘passwd’.
    users.users.sam = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcFIcpkymnv2XQ+mH6dUeVdc2Dt0kBNUweVdTxZw6xMNoa1Wsd7Ro0KgSStnDOO0xc6LvKIovj18QtlQ76D2xlyygxFjtS+q8FrjTeVnsJWl7DTrJXbIzFpP7LutcQ07qKSpL4FYslxTqwyoQs71SlLX2HkKWXHaeRbd/kAqZzRiwf2o/VRD5neNVqDSiOZbyMY7cYkMPtowk787xVUeyQQwzwRfQP1wXwvFwjhNtNe7JjnrPuJxTjTeCeHU1DV5FCt/T7CydyM6EAhrDECwf0rqJmyNs7Gq1Yf2QeMkTra7eM3oQxbjilkhUm1dXHs3pyzbjOMiPTTD2k42e14QEo1/tiJpvJq91jQ/d+zwUU9n/oApQ/FKyY1t0JRob3axEE7xeQfPgWNTDDVPCnP4YapXfOfPrvgRiDR1mZw9Y7fXifLZV0wgQcW/9NGM9NNPre6IG30ZrVBIW3SOIZViBH9xqyaHwubp+ANIKN8reFpntLMOCLv7/+ug3gom83JDU= samweston@Sams-Air.lan.cablespaghetti.dev"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLfRpMNL58CLVQxGpwz+LVMKa6vSSxOBO4Z9tlKYfZPLN2JwMzeYa3OaHP0Oug+/EBkAnq7I/lUDYiYCpBlzux81J3ieG4EcI07QSLVIFPnrCrezEyoxphTu6nd3GIL8n1UIGNPgcFI/JureEDjE0wrmocAHmfAOa8wKvWCvepQEHg34uvTDn9NkRXlMGBibyw2b056xJNjhgPgiy6d3NvGe5ArTJnZMhAA102PzPyM0uDQ/OITLhR8lJeYdDUShAL39H1bQvteRSCmCLeRhb63j0vwukjREAOR46xM6DrxMxAr695sxLtX1WVBnIjsXisRH76tzKj+Z0RXEuk7j9pYKwbKdivQkLJ/8tNoVOvHXe3wFQMqCmoO5Lap8yCokpAEsB/qwKM7N4ygi0gJEtQ52pHG3wrN5iFn7BXr++yET5SvNoEMYKnNqOiI6swZB5miVLR4+YJnQWlW0PbkEwrn5RZ9FBOr3ue9pJLSG8UYnqRpj5Qxj0QFcQMg2C9caM= sam@nixos-yoga"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.sam = {
        home.stateVersion = "23.05";
        programs.git = {
          enable = true;
          userName = "Sam Weston";
          userEmail = "11150054+cablespaghetti@users.noreply.github.com";
          extraConfig.init.defaultBranch = "main";
        };
      };
      users.root = {
        home.stateVersion = "23.05";
        programs.git = {
          enable = true;
          userName = "Sam Weston";
          userEmail = "11150054+cablespaghetti@users.noreply.github.com";
          extraConfig.init.defaultBranch = "main";
        };
      };
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "no";
    };

    # Set up Grafana Agent
    age.secrets.grafana-password = {
      file = ../../secrets/grafana-password.age;
    };
    age.secrets.grafana-logs-password = {
      file = ../../secrets/grafana-logs-password.age;
    };
    services.grafana-agent = {
      enable = true;
      credentials = {
        LOGS_REMOTE_WRITE_PASSWORD = config.age.secrets.grafana-logs-password.path;
        METRICS_REMOTE_WRITE_PASSWORD = config.age.secrets.grafana-password.path;
      };
      settings = {
        metrics = {
          global = {
            scrape_interval = "60s";
            remote_write = [
              {
                basic_auth = {
                  username = "1193016";
                  password = "\${METRICS_REMOTE_WRITE_PASSWORD}";
                };
                url = "https://prometheus-prod-05-gb-south-0.grafana.net/api/prom/push";
              }
            ];
          };
        };
        logs = {
          configs = [
            {
              clients = [
                {
                  basic_auth = {
                    username = "695583";
                    password = "\${LOGS_REMOTE_WRITE_PASSWORD}";
                  };
                  url = "https://logs-prod-008.grafana.net/api/prom/push";
                }
              ];
              name = "default";
              positions = {
                filename = "\${STATE_DIRECTORY}/loki_positions.yaml";
              };
              scrape_configs = [
                {
                  job_name = "journal";
                  journal = {
                    labels = {
                      job = "systemd-journal";
                    };
                    max_age = "12h";
                  };
                  relabel_configs = [
                    {
                      source_labels = [
                        "__journal__systemd_unit"
                      ];
                      target_label = "systemd_unit";
                    }
                    {
                      source_labels = [
                        "__journal__hostname"
                      ];
                      target_label = "nodename";
                    }
                    {
                      source_labels = [
                        "__journal_syslog_identifier"
                      ];
                      target_label = "syslog_identifier";
                    }
                  ];
                }
              ];
            }
          ];
        };

        integrations = {
          agent.enabled = true;
          agent.scrape_integration = true;
          node_exporter.enabled = true;
        };
      };
    };

    # Set up Restic Backups
    age.secrets.restic-environmentfile = {
      file = ../../secrets/restic-environmentfile.age;
      owner = config.services.restic.backups.b2.user;
    };
    age.secrets.restic-password = {
      file = ../../secrets/restic-password.age;
      owner = config.services.restic.backups.b2.user;
    };
    services.restic.backups = {
      b2 = {
        repository = "s3:s3.us-east-005.backblazeb2.com/cablespaghetti-homelab-backups/" + config.networking.hostName;
        initialize = true;
        passwordFile = config.age.secrets.restic-password.path;
        environmentFile = config.age.secrets.restic-environmentfile.path;
        timerConfig = {
          onCalendar = "daily";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-yearly 10"
        ];
      };
    };

    # Setup msmtp for sending notifcation emails
    age.secrets.smtp-username = {
      file = ../../secrets/smtp-username.age;
    };
    age.secrets.smtp-password = {
      file = ../../secrets/smtp-password.age;
    };
    environment.etc = {
      "aliases" = {
        text = "root: " config.networking.hostName + "@cablespaghetti.dev";
        mode = "0644";
      };
    };
    programs.msmtp = {
      enable = true;
      setSendmail = true;
      defaults = {
        aliases = "/etc/aliases";
        port = 587;
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
        tls = "on";
        auth = "login";
        tls_starttls = "off";
      };
      accounts = {
        default = {
          host = "smtp-relay.brevo.com";
          passwordeval = "cat " + config.age.secrets.smtp-password.path;
          user = builtins.readFile config.age.secrets.smtp-username.path;
          from = config.networking.hostName + "@cablespaghetti.dev";
        };
      };
    };
  };
}
