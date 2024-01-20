{
  inputs = {
    nixpkgs.url = "github:cablespaghetti/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
      nixos-web-1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-web-1/hardware-configuration.nix
          ./common/configuration.nix
          ./hosts/nixos-web-1/configuration.nix
          ./hosts/nixos-web-1/wordpress.nix
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
      nixos-web-vps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-web-vps/hardware-configuration.nix
          ./common/configuration.nix
          ./hosts/nixos-web-vps/configuration.nix
          ./hosts/nixos-web-vps/wordpress.nix
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

      nixos-yoga = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-yoga/hardware-configuration.nix
          ./hosts/nixos-yoga/configuration.nix
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
    };
  };
}
