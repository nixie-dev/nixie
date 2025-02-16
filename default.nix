{ lib, python3Packages, fetchPypi, nix-index, nix, hatch, amber-lang
, libfaketime, ... }:

let
  nixie_ver = "2025.02-a1";
  pzp = python3Packages.buildPythonPackage rec {
    pname = "pzp";
    version = "0.0.27";

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

  # By default, Amber adds a header with the build time, which can't be disabled.
  # This wraps the compiler in faketime to make the timestamp reproducible.
  # See amber-lang/amber#672
  amber-reproducible = amber-lang.overrideAttrs (self: super: {
    postInstall = ''
      ${super.postInstall}
      mv $out/bin/amber $out/bin/.amber-orig
      makeWrapper ${libfaketime}/bin/faketime $out/bin/amber \
                  --add-flags "-f '1970-01-01 01:00:00' $out/bin/.amber-orig"
    '';
  });
in python3Packages.buildPythonApplication {
  pname = "nixie";
  version = nixie_ver;

  src = ./.;
  format = "pyproject";

  nativeBuildInputs =
    [ hatch
      hatch-build-scripts
      amber-reproducible
      libfaketime
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
