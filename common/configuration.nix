# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  modules,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    htop
    vim
    curl
    jq
    git
    dua
    tmux
    bmon
    alejandra
    pciutils
    lshw
    smartmontools
    inputs.agenix.packages."${system}".default
  ];

  # enable the tailscale service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    package = pkgs.unstable.tailscale;
  };
  networking.nftables.enable = true;
  services.resolved.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
  };
  services.uptimed.enable = true;
  zramSwap.enable = true;
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
