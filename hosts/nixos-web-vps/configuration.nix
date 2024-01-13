# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  modules,
  ...
}: {
  networking.hostName = "nixos-web-vps";
  networking.firewall = {
    allowedUDPPorts = [config.services.tailscale.port 631];
    allowedTCPPorts = [22 80 443 631];
  };
  documentation.enable = false;
  environment.noXlibs = true;
  i18n.supportedLocales = lib.mkForce [ "en_US.UTF-8/UTF-8" ];
}
