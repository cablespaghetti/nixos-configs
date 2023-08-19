{
  config,
  pkgs,
  modules,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = [brlaser epson-escpr];
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
