{ description = "Flake containing my personal workstation configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-community = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
      rec {
        packages = forAllSystems (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./pkgs { inherit pkgs; }
        );
        devShells = forAllSystems (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./shell.nix { inherit pkgs; }
        );

        overlays = import ./overlays { inherit inputs; };
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
          vortex = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./workstations/vortex/nixos/configuration.nix
            ];
          };
          vortex = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
            modules = [
              .workstations/voyager/nixos/configuration.nix
            ];
          };
        };
      };
}
