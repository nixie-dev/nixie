{ stdenv, boost, openssl, lowdown, nlohmann_json, brotli, libsodium, editline
, gnutar, coreutils, findutils, python3, nix, ... }:

let


  mkConfiguredSrc = { pkg, confScript, dest?pkg.pname }:
    stdenv.mkDerivation {
      inherit (pkg) version src nativeBuildInputs;
      inherit dest;
      pname = "${pkg.pname}-configured-sources";

      configurePhase = confScript;

      dontBuild = true;

      installPhase = ''
        mkdir -p $out
        cp -r $src $out/${dest}
      '';
    };

    nix_configured_src = mkConfiguredSrc { pkg = nix; confScript = "./bootstrap.sh"; };
    editline_configured_src = mkConfiguredSrc
      { pkg = editline;
        confScript = "./autogen.sh";
        dest = "libeditline";
      };
    brotli_configured_src = mkConfiguredSrc
      { pkg = brotli;
        confScript = "./bootstrap";
        dest = "libbrotlicommon";
      };

  srcs_simple =
    [ openssl
      lowdown
      libsodium
    ];
  srcs_dir =
    [ nlohmann_json
    ];
  srcs_configured =
    [ nix_configured_src
      editline_configured_src
      brotli_configured_src
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
      (l: r: l + "\ncp -r ${r.src} ${r.pname} && chmod -R u+w ${r.pname} && tar -czf $out/${r.pname}.tar.gz ${r.pname}") "" srcs_dir
  + builtins.foldl'
      (l: r: l + "\ncp -r ${r}/${r.dest} work && chmod -R u+w work/${r.dest} && tar -C work -czf $out/${r.dest}.tar.gz ${r.dest}") "" srcs_configured
  ;
}
