{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.arion
  ];
  

  virtualisation = {
    docker.enable = true;
    arion = {
      backend = "docker";
      projects.example.settings = {
        imports = [ ./arion-compose.nix ];
      };
    };
  };

  users.extraUsers.sam.extraGroups = ["docker"];
}
