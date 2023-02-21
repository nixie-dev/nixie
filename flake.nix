{ description = "Put Nix in everything!";

  inputs.nixpkgs.url = github:nixos/nixpkgs?ref=nixos-22.11;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.fakedir =
    { url = github:thesola10/fakedir;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

  nixConfig.extra-substituters = "https://nix-wrap.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-wrap.cachix.org-1:FcfSb7e+LmXBZE/MdaFWcs4bW2OQQeBnB/kgWlkZmYI=";

  outputs = { self, nixpkgs, flake-utils, fakedir, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
    in
    { packages = rec
      { default = nixie;
        nixie = pkgs.callPackage ./builder {};
        sources = pkgs.callPackage ./sources {};
        static-bins = pkgs.callPackage ./nix-static-bins.nix
          { inherit nixpkgs fakedir;
            libfakedir = fakedir.packages.${system}.fakedir-universal;
          };
      } // (if system == "x86_64-darwin" || system == "aarch64-darwin"
      then {
        libfakedir = fakedir.packages.${system}.fakedir;
      } else {});
    });
}
