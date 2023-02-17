{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "nix-wrap-sources";
  version = "0.0.1";

  src = ./.;
}
