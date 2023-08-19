# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = ["data"];
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efis/ata-TS64GSSD370_D260800539-part1";
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub = {
    enable = true;
    devices = [
      "/dev/disk/by-id/ata-TS64GSSD370_D260800539"
      "/dev/disk/by-id/ata-TS64GSSD370_D299992734"
    ];
    efiInstallAsRemovable = true;
    copyKernels = true;
    efiSupport = true;
    zfsSupport = true;
    extraInstallCommands = ''
      set -x
      ${pkgs.coreutils-full}/bin/cp -r ${config.boot.loader.efi.efiSysMountPoint}/EFI /boot/efis/ata-TS64GSSD370_D299992734-part1
      set +x
    '';
  };

  fileSystems = {
    "/" = {
      device = "rpool/nixos/root";
      fsType = "zfs";
      options = ["X-mount.mkdir" "noatime"];
      neededForBoot = true;
    };
    "/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
      options = ["X-mount.mkdir" "noatime"];
      neededForBoot = true;
    };
    "/var/lib" = {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
      options = ["X-mount.mkdir" "noatime"];
      neededForBoot = true;
    };
    "/var/log" = {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
      options = ["X-mount.mkdir" "noatime"];
      neededForBoot = true;
    };
    "/boot" = {
      device = "bpool/nixos/root";
      fsType = "zfs";
      options = ["X-mount.mkdir" "noatime"];
      neededForBoot = true;
    };
    "/boot/efis/ata-TS64GSSD370_D260800539-part1" = {
      device = "/dev/disk/by-id/ata-TS64GSSD370_D260800539-part1";
      fsType = "vfat";
      options = [
        "x-systemd.idle-timeout=1min"
        "x-systemd.automount"
        "noauto"
        "nofail"
        "noatime"
        "X-mount.mkdir"
      ];
    };
    "/boot/efis/ata-TS64GSSD370_D299992734-part1" = {
      device = "/dev/disk/by-id/ata-TS64GSSD370_D299992734-part1";
      fsType = "vfat";
      options = [
        "x-systemd.idle-timeout=1min"
        "x-systemd.automount"
        "noauto"
        "nofail"
        "noatime"
        "X-mount.mkdir"
      ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-id/ata-TS64GSSD370_D260800539-part4";
      discardPolicy = "both";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
    {
      device = "/dev/disk/by-id/ata-TS64GSSD370_D299992734-part4";
      discardPolicy = "both";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
