{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, arion, home-manager, nixpkgs, ... } @ inputs:
  {
    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays { inherit inputs; }; 

    nixosConfigurations = {
      nixos-web-1 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./nixos-web-1/hardware-configuration.nix
          ./common/configuration.nix
          ./nixos-web-1/configuration.nix
          ./common/upgrade-diff.nix
          ./nixos-web-1/arion-configuration.nix
          arion.nixosModules.arion
          inputs.home-manager.nixosModules.home-manager
	  { config._module.args = { flake = self; }; }
        ];
      };

      chonky = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./chonky/hardware-configuration.nix
          ./common/configuration.nix
          ./chonky/configuration.nix
          ./common/upgrade-diff.nix
          arion.nixosModules.arion
          inputs.home-manager.nixosModules.home-manager
	  { config._module.args = { flake = self; }; }
        ];
      };
    };
  };
}
