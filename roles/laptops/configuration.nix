# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  lib,
  pkgs,
  modules,
  inputs,
  ...
}: {
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "gb";

  # Configure console keymap
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsing = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  hardware.opengl.enable = true;

  # Styling
  #  fonts = {
  #    fonts = with pkgs; [
  #      noto-fonts
  #      noto-fonts-emoji
  #    ];
  #
  #    fontconfig = {
  #      # Fixes pixelation
  #      antialias = true;
  #
  #      # Fixes antialiasing blur
  #      hinting = {
  #        enable = true;
  #        style = "hintfull"; # no difference
  #        autohint = true; # no difference
  #      };
  #
  #      subpixel = {
  #        # Makes it bolder
  #        rgba = "rgb";
  #        lcdfilter = "default"; # no difference
  #      };
  #    };
  #  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sam = {
    isNormalUser = true;
    description = "Sam Weston";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
  ];

  virtualisation.docker = {
    enable = true;
  };

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    imagemagick

    # Can't live without these either
    floorp
    gnome.gnome-tweaks
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
    joplin
    joplin-desktop
    gimp
    beeper
    tilix
    rclone
    libreoffice
    _86Box

    # I am DevOps
    awscli2
    opentofu
    kubectl
    kubectx
    fluxcd
    kubernetes-helm
    nmap
    python3
    python311Packages.pip
    pipenv
    hugo
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        redhat.vscode-yaml
        hashicorp.terraform
        kamadorueda.alejandra
      ];
    })
  ];
}
