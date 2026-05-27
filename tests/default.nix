{ nixpkgs, nixie, sources, static-bins
, system ? builtins.currentSystem, nix-darwin ? {}, ... }@as:

let
  pkgs = import nixpkgs { inherit system; };

  makeDarwinTest = featureName: configuration: import ./template-darwin.nix { inherit pkgs configuration featureName sources static-bins; };
  makeLinuxTest = featureName: configuration: import ./template-linux.nix { inherit pkgs configuration featureName sources static-bins; };

  makeTest =
    if pkgs.stdenv.isLinux       then makeLinuxTest
    else if pkgs.stdenv.isDarwin then makeDarwinTest
    else throw "Unsupported platform: ${pkgs.stdenv.platform}";

  defaultConfig = {
    environment.systemPackages = with pkgs; [
      nixie git
    ];
  };
in {

  # Tests available on both platforms
  building   = makeTest "building" {
    environment.systemPackages = with pkgs; [
      nixie git
      gcc pkg-config gnumake flex bison perl
    ];
  };
  generation = makeTest "generation" defaultConfig;
  migration  = makeTest "migration" (defaultConfig // {
    virtualisation.writableStore = true;
  });
  rootless   = makeTest "rootless" defaultConfig;

} // (if pkgs.stdenv.isLinux then {

  # Linux-specific tests go here

} else if pkgs.stdenv.isDarwin then {

  # macOS-specific tests go here

} else {})
