{
  inputs.nixpkgs.url = github:nixos/nixpkgs?ref=nixos-22.11;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system: 
    let pkgs = nixpkgs.legacyPackages.${system};
    in
    { packages.${system} = rec
      { default = nix-wrap;
        nix-wrap = pkgs.callPackage ./builder {};
        sources = pkgs.callPackage ./sources {};
        static-bins = pkgs.callPackage ./nix-static-bins.nix {};
      };
    });
}
