self: super:
{ libcCross = super.buildPackages.darwin.Libsystem;

  #targetPackages = super.targetPackages // {
  #  libcCross = self.libcCross;
  #  darwin = self.darwin;
  #};

  runtimeShellPackage = super.pkgsBuildBuild.bash;

  # Setting this prevents static libc++ from being used
  targetPackages = self;

  # Workaround for nixos/nixpkgs#127345
  boost = super.boost.overrideAttrs(o: {
    buildPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.buildPhase;
    installPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.installPhase;
  });

  nixStatic = self.nix.overrideAttrs (o: rec {
    nix_LDFLAGS = "-nodefaultlibs -nostdlib ${super.pkgsBuildBuild.libcxx}/lib/libc++.a ${super.pkgsBuildBuild.libcxx}/lib/libc++experimental.a ${super.pkgsBuildBuild.libcxxabi}/lib/libc++abi.a -lSystem";
    postConfigure = ''
      sed -e 's,-Ur,-r,' mk/libraries.mk -i
      sed -e 's,nix_LDFLAGS =,nix_LDFLAGS = ${nix_LDFLAGS},' src/nix/local.mk -i
    '';
  });
}
