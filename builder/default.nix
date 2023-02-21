{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "nixie";
  version = "0.0.1";

  src = ./.;
}
