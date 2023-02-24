{ lib, python3Packages, ... }:

python3Packages.buildPythonApplication {
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
    [ flit-core
    ];

  propagatedBuildInputs = with python3Packages;
    [ click
      rich
      click-option-group
    ];
}
