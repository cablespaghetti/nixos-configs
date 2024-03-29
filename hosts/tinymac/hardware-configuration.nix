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
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Run latest upstream kernel
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "wl"];
  boot.kernelParams = ["hid_apple.iso_layout=1" "acpi_osi="];
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8bc1ec94-f630-42d5-b3a7-545f457c2fe0";
    fsType = "f2fs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0280-BF5D";
    fsType = "vfat";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = false;
  #networking.interfaces.wlp2s0.useDHCP = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.acpid.enable = true;
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.facetimehd.enable = true;
  services.mbpfan.enable = true;
  services.fstrim.enable = true;
  services.xserver.xkb.variant = "mac";
}
