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
    allowedUDPPorts = [config.services.tailscale.port];
    allowedTCPPorts = [443];
  };
  services.openssh.openFirewall = false;
  documentation.enable = false;
  environment.noXlibs = true;
}
