{ description = "Put Nix in everything!";

  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.nix =
    { url = github:nixos/nix/2.14.1;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  inputs.fakedir =
    { url = github:nixie-dev/fakedir;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

  nixConfig.extra-substituters = "https://nix-wrap.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-wrap.cachix.org-1:FcfSb7e+LmXBZE/MdaFWcs4bW2OQQeBnB/kgWlkZmYI=";

  outputs = { self, nixpkgs, flake-utils, fakedir, nix, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
    in
    { packages = rec
      { default = nixie;
        nixie = pkgs.callPackage ./builder {};
        sources = pkgs.callPackage ./sources {};
        static-bins = import ./nix-static-bins.nix
          { inherit nixpkgs fakedir pkgs;
            libfakedir = fakedir.packages.aarch64-darwin.fakedir-universal;
            nixStatics."aarch64-linux" = nix.packages.aarch64-linux.nix-static;
          };
      } // (if system == "x86_64-darwin" || system == "aarch64-darwin"
      then {
        libfakedir = fakedir.packages.${system}.fakedir;
      } else {});
    });
}
