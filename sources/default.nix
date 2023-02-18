{ stdenv, boost, openssl, lowdown, nlohmann_json, brotli, libsodium, editline
, gnutar, coreutils, findutils, python3, ... }:

let
  srcs_simple =
    [ openssl
      lowdown
      libsodium
    ];
  srcs_dir =
    [ nlohmann_json
      # I want pname to match the pkg-config package checked against like in the script
      (brotli.overrideAttrs (_: { pname = "libbrotlicommon"; }))
      (editline.overrideAttrs (_: { pname = "libeditline"; }))
    ];
in stdenv.mkDerivation {
  pname = "nix-wrap-sources";
  version = "0.0.1";

  dontInstall = true;

  src = ./.;

  nativeBuildInputs =
    [ coreutils
      findutils
      python3
    ];

  buildPhase = ''
    mkdir -p $out
    make BOOST_ARCHIVE=${boost.src} BOOST_VER=${boost.version} TAR=${gnutar}/bin/tar
    cp boost-shaved.tar.gz $out/boost.tar.gz
  ''
  + builtins.foldl'
      (l: r: l + "\npython3 ./tarmod.py ${r.src} $out/${r.pname}.tar.gz ${r.pname}") "" srcs_simple
  + builtins.foldl'
      (l: r: l + "\ntar --transform='s,.*nix/store/[a-z0-9-]*-source/,${r.pname}/,' -czf $out/${r.pname}.tar.gz ${r.src}") "" srcs_dir
  ;
}
