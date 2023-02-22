{ nixpkgs ? <nixpkgs>
, fakedir ? builtins.fetchGit "https://github.com/thesola10/fakedir"
, pkgs ? import nixpkgs {}
, libfakedir ? pkgs.callPackage fakedir
, ... }:

let
  builtSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  systemsNixpkgs =
    map (s:
      let parsedSystem = pkgs.lib.systems.parse.mkSystemFromString s;
          unmoddedPkgs = import nixpkgs { system = s; };
      in import nixpkgs ({ localSystem = s; }
      // (if parsedSystem.kernel.name == "darwin"
          then
          { overlays =
            [ (import ./nixpkgs-darwin-static.nix)
            (self: super: {

                boost = super.boost.overrideAttrs(o: {
                  buildPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.buildPhase;
                  installPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.installPhase;
                });
                nixStatic = self.nix.overrideAttrs (o: {
                  configureFlags = o.configureFlags ++ [
                    "--disable-shared"
                  ];
                  postConfigure = ''
                    sed -e 's,-Ur,-r,' mk/libraries.mk -i
                    sed -e 's,nix_LDFLAGS = ,nix_LDFLAGS = -L${self.libcxx} -L${self.libcxxabi},' src/nix/local.mk
                  '';
                });
              })
            ];
            crossSystem = {
              isStatic = true;
              system = s;
            };
          }
          else {}))
    ) builtSystems;
in
pkgs.stdenv.mkDerivation {
  pname = "nix-static-binaries";
  version = "0.0.1";
  src = pkgs.emptyDirectory;

  installPhase =
    (let
      sys = r: r.stdenv.hostPlatform.uname.system;
      cpu = r: r.stdenv.hostPlatform.uname.processor;
    in builtins.foldl'
      (l: r: "${l}; cp ${r.nixStatic}/bin/nix $out/nix.${sys r}.${cpu r}")
      "mkdir -p $out"
      systemsNixpkgs)
    + "; cp ${libfakedir}/lib/libfakedir.dylib $out/libfakedir.dylib";
} // builtins.foldl'
  (l: r: l // { "${r.system}-nix-static" = r.nixStatic; })
  { fakedir = libfakedir; } systemsNixpkgs
