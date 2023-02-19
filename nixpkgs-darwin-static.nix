self: super:

let
  mkStatic = p:
  let
    auto = builtins.intersectAttrs (super.lib.functionArgs p.override)
    { enableStatic = true; enableShared = false; };
  in p.override auto;
in {
  nixStatic = self.nix.override {
    enableStatic = true;
    withLibseccomp = false;
    withAWS = false;
  };
  boost       = mkStatic super.boost;
  brotli      = mkStatic super.brotli;
  bzip2       = mkStatic super.bzip2;
  curl        = mkStatic super.curl;
  editline    = mkStatic super.editline;
  libsodium   = mkStatic super.libsodium;
  openssl     = mkStatic super.openssl;
  sqlite      = mkStatic super.sqlite;
  xz          = mkStatic super.xz;
  libarchive  = mkStatic super.libarchive;
  lowdown     = mkStatic super.lowdown;
  gtest       = mkStatic super.gtest;
  boehmgc     = mkStatic super.boehmgc;
}
