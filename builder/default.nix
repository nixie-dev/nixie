{ lib, python3Packages, fetchPypi, ... }:

let
  pzp = python3Packages.buildPythonPackage rec {
    pname = "pzp";
    version = "0.0.19";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-SU9v7WPIAY8qKYrzp9KC+8yysGVGHcwcPmGvDb/0nik=";
    };

    doCheck = false;
  };
in python3Packages.buildPythonApplication {
  pname = "nixie";
  version = "0.0.1";

  src = ./.;
  format = "pyproject";

  preConfigure = ''
    rm README.md LICENSE
    cp ${../README.md} README.md
    cp ${../LICENSE}   LICENSE
  '';

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
    ];
}
