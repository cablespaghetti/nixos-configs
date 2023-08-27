{
  config,
  pkgs,
  modules,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.brlaser pkgs.epson-escpr];
    browsing = true;
    listenAddresses = ["*:631"];
    allowFrom = ["all"];
    defaultShared = true;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
