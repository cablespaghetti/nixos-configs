# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  modules,
  ...
}: {
  networking.hostName = "chonky";
  networking.hostId = "8ad47da0";
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
  networking.firewall = {
    allowedUDPPorts = [config.services.tailscale.port 631 config.services.atftpd.port];
    allowedTCPPorts = [22 631 80 443 8080];
  };
  environment.systemPackages = with pkgs; [get_iplayer sanoid hdparm];

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
  services.prometheus.exporters.smartctl.enable = true;
  services.grafana-agent = {
    settings = {
      metrics = {
        configs = [
          {
            name = "smartctl";
            scrape_configs = [
              {
                job_name = "smartctl";
                static_configs = [
                  {targets = ["localhost:9633"];}
                ];
              }
            ];
          }
        ];
      };
    };
  };
  services.atftpd.enable = true;
}
