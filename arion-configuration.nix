{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.arion
    pkgs.docker-client
  ];
  

  virtualisation = {
    podman = {
      enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    arion = {
      backend = "podman-socket";
      projects.example.settings = {
        imports = [ ./arion-compose.nix ];
      };
    };
  };

  users.extraUsers.sam.extraGroups = ["podman"];
}
