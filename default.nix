{ lib, python3Packages, fetchPypi, nix-index, nix, hatch, amber-lang
, ... }:

let
  nixie_ver = "2025.02-a2";
  pzp = python3Packages.buildPythonPackage rec {
    pname = "pzp";
    version = "0.0.28";
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-xO3x2v5yT5cxz4pa7Ug/f2sQFkJcMIVSWLfj/Lm70E4=";
    };

    doCheck = false;
  };
in python3Packages.buildPythonApplication {
  pname = "nixie";
  version = nixie_ver;

  src = ./.;
  format = "pyproject";

  nativeBuildInputs = with python3Packages;
    [ hatch
      hatch-build-scripts
      amber-lang
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
