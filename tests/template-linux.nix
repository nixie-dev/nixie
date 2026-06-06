{ pkgs, configuration, sources, static-bins
, featurePath ? ./features
, featureName
, ... }@opts:

pkgs.testers.nixosTest {
  name = featureName;
  nodes = { machine = configuration; };

  extraPythonPackages = p: with p; [ behave allure-behave ];

  skipTypeCheck = true;

  testScript = ''
    from behave.configuration import Configuration
    from behave.__main__ import run_behave

    def succeed(cmd):
      return machine.succeed(cmd)

    def fail(cmd):
      return machine.fail(cmd)

    conf = Configuration("${featurePath}/${featureName}.feature", userdata = { "succeed": succeed, "fail": fail, "sources": "${sources}", "static_bins": "${static-bins}" })
    conf.format = [ "allure_behave.formatter:AllureFormatter", "pretty" ]
    conf.outputs = []
    conf.setup_outputs(['allure_output'])
    start_all()
    exit(run_behave(conf))
  '';
}
