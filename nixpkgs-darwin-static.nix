self: super:
{ darwin = super.darwin // {
    Libsystem = super.buildPackages.darwin.Libsystem;
    LibsystemCross = super.buildPackages.darwin.Libsystem;
  };

  libcCross = super.buildPackages.darwin.Libsystem;

  targetPackages = self;
}
