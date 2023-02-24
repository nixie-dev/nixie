self: super:
{ darwin = super.darwin // {
    Libsystem = super.buildPackages.darwin.Libsystem;
    LibsystemCross = super.buildPackages.darwin.Libsystem;
  };

  libcCross = super.buildPackages.darwin.Libsystem;

  runtimeShellPackage = super.buildPackages.bash;

  # Setting this prevents static libc++ from being used
  #targetPackages = self;

  # Workaround for nixos/nixpkgs#127345
  boost = super.boost.overrideAttrs(o: {
    buildPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.buildPhase;
    installPhase = builtins.replaceStrings ["binary-format=macho"] ["binary-format=mach-o"] o.installPhase;
  });

  nixStatic = self.nix.overrideAttrs (o: {
    postConfigure = ''
      sed -e 's,-Ur,-r,' mk/libraries.mk -i
    '';
  });
}
