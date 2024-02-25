{config, ...}: {
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
        OnCalendar = "02:05";
        RandomizedDelaySec = "2h";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-yearly 10"
      ];
    };
  };
}
