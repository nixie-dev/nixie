{ description = "Put Nix in everything!";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    amber.url   = github:amber-lang/amber;
    nix.url     = github:nixos/nix/2.26.2;
    fakedir = {
      url = github:nixie-dev/fakedir;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    # Only required for macOS unit tests
    nix-darwin.url = github:nix-darwin/nix-darwin;
  };

  nixConfig.extra-substituters = "https://nix-wrap.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-wrap.cachix.org-1:FcfSb7e+LmXBZE/MdaFWcs4bW2OQQeBnB/kgWlkZmYI=";

  outputs = { self, nix, nixpkgs, nix-darwin, flake-utils, fakedir, amber, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
        amber-lang = amber.outputs.packages.${system}.default;
    in
    { packages = rec
      { default = nixie;
        nixie = pkgs.callPackage ./. { inherit amber-lang; };
        sources = pkgs.callPackage ./sources
          { nix-source = nix;
          };
        static-bins = import ./static-bins
          { inherit nixpkgs fakedir pkgs;
            nix-source = nix;
            libfakedir = fakedir.packages.aarch64-darwin.fakedir-universal;
          };

      } // (if system == "x86_64-darwin" || system == "aarch64-darwin"
      then {
        libfakedir = fakedir.packages.${system}.fakedir;
      } else {});

      checks = import ./tests {
        inherit nixpkgs system nix-darwin;
        inherit (self.outputs.packages.${system}) nixie sources static-bins;
      };

      devShells = {
        default = pkgs.mkShell {
          # These dependencies aren't involved in the build process, but are
          # nice-to-haves in the dev environment
          packages = with pkgs; [ bumpver libllvm ];

          inputsFrom = [ self.packages."${system}".nixie ];
        };
      };
    });
}
