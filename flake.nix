{ description = "Put Nix in everything!";

  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.amber.url = github:thesola10/amber/nameof-function;
  inputs.nix.url = github:nixos/nix/2.17.1;
  inputs.fakedir =
    { url = github:nixie-dev/fakedir;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

  nixConfig.extra-substituters = "https://nix-wrap.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-wrap.cachix.org-1:FcfSb7e+LmXBZE/MdaFWcs4bW2OQQeBnB/kgWlkZmYI=";

  outputs = { self, nix, nixpkgs, flake-utils, fakedir, amber, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
        amber-lang = amber.outputs.packages.${system}.default;
    in
    { packages = rec
      { default = nixie;
        nixie = pkgs.callPackage ./. { inherit amber-lang; };
        sources = pkgs.callPackage ./sources {};
        static-bins = import ./static-bins
          { inherit nixpkgs fakedir pkgs;
            libfakedir = fakedir.packages.aarch64-darwin.fakedir-universal;
            nixStatics.aarch64-linux = nix.packages.aarch64-linux.nix-static;
          };

      } // (if system == "x86_64-darwin" || system == "aarch64-darwin"
      then {
        libfakedir = fakedir.packages.${system}.fakedir;
      } else {});

      devShells = {
        default = pkgs.mkShell {
          # These dependencies aren't involved in the build process, but are
          # nice-to-haves in the dev environment
          packages = with pkgs; [ bumpver ];

          inputsFrom = [ self.packages."${system}".nixie ];
        };
      };
    });
}
