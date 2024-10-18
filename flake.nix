{
  description = "Personal repository of nix packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
  in {
    packages.${system} = {
      autofirma = import ./autofirma {pkgs = unstable-pkgs;};
      catapult = import ./catapult {inherit pkgs;};
    };
  };
}
