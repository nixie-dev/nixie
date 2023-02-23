self: super:
{ darwin = super.darwin // {
    Libsystem = super.buildPackages.darwin.Libsystem;
    LibsystemCross = super.buildPackages.darwin.Libsystem;
  };

  libcCross = super.buildPackages.darwin.Libsystem;

  # Final linking needs to be done against static libc++ and libc++abi
  # so we re-wrap clang to use our static versions.
  finalStdenv = super.stdenv // {
    cc = super.buildPackages.clang.override {
      libcxx = super.libcxx;
      extraPackages = with super;
      [ libcxxabi
        buildPackages.llvmPackages.compiler-rt
      ];
    };
    shellPackage = super.buildPackages.bash;
  };

  runtimeShellPackage = super.buildPackages.bash;

  targetPackages = self;

  # Workaround for nixos/nixpkgs#127345
  boost = super.boost.overrideAttrs(o: {
    buildPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.buildPhase;
    installPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.installPhase;
  });

  nixStatic = (self.nix.override { stdenv = self.finalStdenv; }).overrideAttrs (o: {
    postConfigure = ''
      sed -e 's,-Ur,-r,' mk/libraries.mk -i
    '';
  });
}
