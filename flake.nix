{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cloudflare-caddy = {
      url = "github:burmudar/nix-cloudflare-caddy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    cloudflare-caddy,
    flake-utils,
    agenix,
    ...
  } @ inputs: let
    overlays = import ./overlays {inherit inputs;};
    pkgs =
      (inputs.flake-utils.lib.eachSystem ["x86_64-linux"] (system: {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            cloudflare-caddy.overlay
            overlays.unstable-packages
          ];
          config = {allowUnfree = true;};
        };
      }))
      .pkgs;
  in {
    nixosConfigurations = {
      nixos-web-bakery = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-web-bakery/hardware-configuration.nix
          ./common/configuration.nix
          ./hosts/nixos-web-bakery/configuration.nix
          ./hosts/nixos-web-bakery/prestashop.nix
          ./common/upgrade-diff.nix
          ./roles/servers/configuration.nix
          ./roles/servers/restic.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgs.x86_64-linux;
          inputs = inputs;
        };
      };
      chonky = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/chonky/hardware-configuration.nix
          ./common/configuration.nix
          ./hosts/chonky/configuration.nix
          ./hosts/chonky/jellyfin.nix
          ./hosts/chonky/transmission.nix
          ./hosts/chonky/nzb.nix
          ./hosts/chonky/printer.nix
          ./hosts/chonky/joplin.nix
          ./hosts/chonky/samba.nix
          ./hosts/chonky/syncoid.nix
          ./common/upgrade-diff.nix
          ./roles/servers/configuration.nix
          ./roles/servers/restic.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgs.x86_64-linux;
          inputs = inputs;
        };
      };

      tinymac = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/tinymac/hardware-configuration.nix
          ./hosts/tinymac/configuration.nix
          ./common/configuration.nix
          ./common/upgrade-diff.nix
          ./roles/laptops/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgs.x86_64-linux;
          inputs = inputs;
        };
      };

      snail = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/snail/chrome-device.nix
          ./hosts/snail/hardware-configuration.nix
          ./hosts/snail/configuration.nix
          ./common/configuration.nix
          ./common/upgrade-diff.nix
          ./roles/laptops/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgs.x86_64-linux;
          inputs = inputs;
        };
      };

      runningcafe-web1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/runningcafe-web1/hardware-configuration.nix
          ./hosts/runningcafe-web1/configuration.nix
          ./common/configuration.nix
          ./common/upgrade-diff.nix
          ./roles/servers/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgs.x86_64-linux;
          inputs = inputs;
        };
      };
      runningcafe-web2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/runningcafe-web2/hardware-configuration.nix
          ./hosts/runningcafe-web2/configuration.nix
          ./hosts/runningcafe-web2/wordpress.nix
          ./common/configuration.nix
          ./common/upgrade-diff.nix
          ./roles/servers/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgs.x86_64-linux;
          inputs = inputs;
        };
      };
    };
  };
}
