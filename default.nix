{ lib, python3Packages, fetchPypi, nix-index, nix, hatch, amber-lang
, ... }:

let
  nixie_ver = "2025.02-a2";
  pzp = python3Packages.buildPythonPackage rec {
    pname = "pzp";
    version = "0.0.27";
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-HwsOJA3spcCUFvIBLFkSpMIPZgcU9r1JkAgt0Cj/oUg=";
    };

    doCheck = false;
  };
  hatch-build-scripts = python3Packages.buildPythonPackage rec {
    pname = "hatch-build-scripts";
    version = "0.0.4";
    format = "pyproject";

    buildInputs =
      [ hatch
      ];

    src = fetchPypi {
      inherit version;
      pname = "hatch_build_scripts";
      sha256 = "sha256-x4UgmGkH5HU48suyT95B7fwsxV9FK1Ni+64Vzk5jRPc=";
    };
  };
in python3Packages.buildPythonApplication {
  pname = "nixie";
  version = nixie_ver;

  src = ./.;
  format = "pyproject";

  nativeBuildInputs =
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
