{pkgs, ...}: {
  environment.systemPackages = [pkgs.arion];

  virtualisation = {
    arion = {
      backend = "docker";
    };
    docker = {
      storageDriver = "zfs";
    };
  };

  users.extraUsers.sam.extraGroups = ["docker"];
}
