{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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
          ./nixos-web-1/hardware-configuration.nix
          ./common/configuration.nix
          ./nixos-web-1/configuration.nix
          ./common/upgrade-diff.nix
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
          ./chonky/hardware-configuration.nix
          ./common/configuration.nix
          ./chonky/configuration.nix
          ./chonky/jellyfin.nix
          ./chonky/transmission.nix
          ./chonky/printer.nix
          ./chonky/joplin.nix
          ./common/upgrade-diff.nix
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
