{
  config,
  pkgs,
  ...
}: {
  config.services.murmur = {
    enable = true;
    openFirewall = true;
  };
}
