{ lib, python3Packages, fetchPypi, ... }:

let
  pzp = python3Packages.buildPythonPackage rec {
    pname = "pzp";
    version = "0.0.20";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-qr+s9lDHknBwKC6XaxuzhSGYZeHCJwo5ox/zwfC0JSo=";
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
