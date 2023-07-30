{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, arion, home-manager, nixpkgs } @ inputs: {
    nixosConfigurations = {
      nixos-web-1 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix
          ./upgrade-diff.nix
          arion.nixosModules.arion
          ./arion-configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
