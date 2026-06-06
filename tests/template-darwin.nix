{ nixpkgs, configuration, nix-darwin, system, sources, static-bins
, featurePath ? ./features
, featureName
, ... }@opts:

let
  buildFromConfig = configuration: sel: sel
    (import nix-darwin { inherit nixpkgs configuration system; }).config;

  configuration =
    { config, lib, pkgs, ... }:
    with lib;
    {
      imports = [ opts.configuration ];

      options = {
        out = mkOption {
          type = types.package;
        };
      };

      config = {
        environment.systemPackages = [
          (pkgs.python3.withPackages (ps: with ps; [ behave allure-behave ]))
        ];
        system.stateVersion = lib.mkDefault config.system.maxStateVersion;

        system.build.run-test = pkgs.runCommand "darwin-test-${featureName}"
          { allowSubstitutes = false; preferLocalBuild = true; }
          ''
            #! ${pkgs.stdenv.shell}
            set -e

            echo >&2 "running tests for system ${config.out}"
            echo >&2
            python3 <<EOF
              from behave.configuration import Configuration
              from behave.__main__ import run_behave

              import os

              def succeed(cmd):
                return os.system(cmd)

              def fail(cmd):
                try:
                  os.system(cmd)
                except:
                  return true
                raise AssertionError(f"Command '{cmd}' succeeded unexpectedly")

              conf = Configuration("${featurePath}/${featureName}.feature", userdata = { "succeed": succeed, "fail": fail, "sources": "${sources}", "static_bins": "${static-bins}" })
              conf.format = [ "allure_behave.formatter:AllureFormatter", "pretty" ]
              conf.outputs = []
              conf.setup_outputs(['allure_output'])

              exit(run_behave(conf))
            EOF
            echo >&2 ok
            touch $out
          '';

        out = config.system.build.toplevel;
      };
    };
in
  buildFromConfig configuration (config: config.system.build.run-test)
