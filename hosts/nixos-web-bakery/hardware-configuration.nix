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
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
  boot.tmp.cleanOnBoot = true;

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    defaultGateway = {
      address = "45.133.117.1";
      interface = "enp3s0";
    };
    defaultGateway6 = {
      address = "2a12:9080:1::1";
      interface = "enp3s0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      enp3s0 = {
        ipv4.addresses = [
          {
            address = "45.133.117.157";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a12:9080:1:9c::a";
            prefixLength = 64;
          }
          {
            address = "fe80::2a5:d7ff:fe70:d619";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "45.133.117.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "2a12:9080:1::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="00:a5:d7:70:d6:19", NAME="enp3s0"

  '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
