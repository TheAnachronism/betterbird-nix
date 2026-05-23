{
  description = "Betterbird Flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages.${system} = {
        default = pkgs.callPackage ./package.nix {};
        betterbird = self.packages.${system}.default;
      };

      overlays.default = final: prev: {
        betterbird = prev.callPackage ./package.nix {};
      };
    };
}