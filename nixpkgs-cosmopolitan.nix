# cosmopolitan ia a ridiculous hack lol
# but then again, isn't nixie one too?
# if cosmopolitan works out, local builds might become obsolete!

self: super:
{ nixCosmo = super.nixStatic.overrideAttrs (old:
  let cosmo = super.cosmopolitan;
      cosmoc = super.cosmocc;
  in {
    hardeningEnable = [];
    NIX_CC = "${cosmoc}/bin/cosmocc";
    NIX_CXX = "${cosmoc}/bin/cosmoc++";
    CXXFLAGS="-I${super.nlohmann_json}/include -fexceptions";
    configureFlags = old.configureFlags ++ [
      "CC=${cosmoc}/bin/cosmocc"
      "CXX=${cosmoc}/bin/cosmoc++"
      "--disable-seccomp-sandboxing"
      "--with-boost=${super.pkgsStatic.boost.dev}"
      "NLOHMANN_JSON_CFLAGS=-I${super.nlohmann_json}/include"
    ];

    preConfigure = ''
      sed -i configure.ac -e "s/.*gtest.*//g"
      rm -f src/libutil/tests/*.cc
    '';
  });
}
