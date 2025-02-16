{ lib, python3Packages, fetchPypi, nix-index, nix, ... }:

let
  nixie_ver = "2025.02-a1";
  pzp = python3Packages.buildPythonPackage rec {
    pname = "pzp";
    version = "0.0.22";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-RPx0nnB9+cC/n7eOX0hF21TxM/yEkGy/akRnqV/YN8E=";
    };

    doCheck = false;
  };
in python3Packages.buildPythonApplication {
  pname = "nixie";
  version = nixie_ver;

  src = "${../.}/builder";
  format = "pyproject";

  nativeBuildInputs = with python3Packages;
    [ setuptools
    ];

  propagatedBuildInputs = with python3Packages;
    [ click
      rich
      click-option-group
      python-dotenv
      pzp
      gitpython
      nix-index
      nix
    ];
}
