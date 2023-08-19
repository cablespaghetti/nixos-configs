# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  flake,
  config,
  pkgs,
  modules,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "Etc/UTC";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Define a user account. Don't forgeddt to set a password with ‘passwd’.
  users.users.sam = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcFIcpkymnv2XQ+mH6dUeVdc2Dt0kBNUweVdTxZw6xMNoa1Wsd7Ro0KgSStnDOO0xc6LvKIovj18QtlQ76D2xlyygxFjtS+q8FrjTeVnsJWl7DTrJXbIzFpP7LutcQ07qKSpL4FYslxTqwyoQs71SlLX2HkKWXHaeRbd/kAqZzRiwf2o/VRD5neNVqDSiOZbyMY7cYkMPtowk787xVUeyQQwzwRfQP1wXwvFwjhNtNe7JjnrPuJxTjTeCeHU1DV5FCt/T7CydyM6EAhrDECwf0rqJmyNs7Gq1Yf2QeMkTra7eM3oQxbjilkhUm1dXHs3pyzbjOMiPTTD2k42e14QEo1/tiJpvJq91jQ/d+zwUU9n/oApQ/FKyY1t0JRob3axEE7xeQfPgWNTDDVPCnP4YapXfOfPrvgRiDR1mZw9Y7fXifLZV0wgQcW/9NGM9NNPre6IG30ZrVBIW3SOIZViBH9xqyaHwubp+ANIKN8reFpntLMOCLv7/+ug3gom83JDU= samweston@Sams-Air.lan.cablespaghetti.dev"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLfRpMNL58CLVQxGpwz+LVMKa6vSSxOBO4Z9tlKYfZPLN2JwMzeYa3OaHP0Oug+/EBkAnq7I/lUDYiYCpBlzux81J3ieG4EcI07QSLVIFPnrCrezEyoxphTu6nd3GIL8n1UIGNPgcFI/JureEDjE0wrmocAHmfAOa8wKvWCvepQEHg34uvTDn9NkRXlMGBibyw2b056xJNjhgPgiy6d3NvGe5ArTJnZMhAA102PzPyM0uDQ/OITLhR8lJeYdDUShAL39H1bQvteRSCmCLeRhb63j0vwukjREAOR46xM6DrxMxAr695sxLtX1WVBnIjsXisRH76tzKj+Z0RXEuk7j9pYKwbKdivQkLJ/8tNoVOvHXe3wFQMqCmoO5Lap8yCokpAEsB/qwKM7N4ygi0gJEtQ52pHG3wrN5iFn7BXr++yET5SvNoEMYKnNqOiI6swZB5miVLR4+YJnQWlW0PbkEwrn5RZ9FBOr3ue9pJLSG8UYnqRpj5Qxj0QFcQMg2C9caM= sam@nixos-yoga"
    ];
  };

  nixpkgs = {
    overlays = [flake.overlays.unstable-packages];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [wget htop vim curl git];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.sam = {
      home.stateVersion = "23.05";
      programs.git = {
        enable = true;
        userName = "Sam Weston";
        userEmail = "11150054+cablespaghetti@users.noreply.github.com";
        extraConfig.init.defaultBranch = "main";
      };
    };
    users.root = {
      home.stateVersion = "23.05";
      programs.git = {
        enable = true;
        userName = "Sam Weston";
        userEmail = "11150054+cablespaghetti@users.noreply.github.com";
        extraConfig.init.defaultBranch = "main";
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # enable the tailscale service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    package = pkgs.unstable.tailscale;
  };
  networking.nftables.enable = true;
  services.resolved.enable = true;
  networking.useNetworkd = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
    allowedTCPPorts = [22];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
