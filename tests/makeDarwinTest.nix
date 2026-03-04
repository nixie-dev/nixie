{ nixpkgs, nixie, sources, static-bins
, system ? builtins.currentSystem, nix-darwin ? {}, ... }@as:

let
  buildFromConfig = configuration: sel: sel
    (import ./. { inherit nixpkgs configuration system; }).config;
in

test:
  let
    testName =
      builtins.replaceStrings [ ".nix" ] [ "" ]
        (builtins.baseNameOf test);

    configuration =
      { config, lib, pkgs, ... }:
      with lib;
      {
        imports = [ test ];

        options = {
          out = mkOption {
            type = types.package;
          };

          test = mkOption {
            type = types.lines;
          };
        };

        config = {
          system.stateVersion = lib.mkDefault config.system.maxStateVersion;

          system.build.run-test = pkgs.runCommand "darwin-test-${testName}"
            { allowSubstitutes = false; preferLocalBuild = true; }
            ''
              #! ${pkgs.stdenv.shell}
              set -e

              echo >&2 "running tests for system ${config.out}"
              echo >&2
              ${config.test}
              echo >&2 ok
              touch $out
            '';

          out = config.system.build.toplevel;
        };
      };
  in
    buildFromConfig configuration (config: config.system.build.run-test)
