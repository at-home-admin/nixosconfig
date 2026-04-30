{
  description = "IDUNN Nix Configuration";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";

    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      ...
    }:
    {
      nixosConfigurations."EXILE" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bfoster = import ./home.nix;
              backupFileExtension = "backup";
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
              system = "x86_64-linux";
            };
          }
        ];
      };
    };
}
