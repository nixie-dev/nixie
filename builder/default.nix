{ stdenv, ... }:

stdenv.mkDerivation {
  pname = "nix-wrap";
  version = "0.0.1";

  src = ./.;
}
