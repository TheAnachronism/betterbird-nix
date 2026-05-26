{
  description = "Betterbird Flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        betterbird = pkgs.callPackage ./package.nix {};
        default = self.packages.${system}.betterbird;
      };

      overlays.default = final: prev: {
        betterbird = final.callPackage ./package.nix {};
      };
    };
}