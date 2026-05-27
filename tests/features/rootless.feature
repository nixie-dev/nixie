Feature: Nixie can launch Nix without root privileges

    Scenario: Rootless
        Given a Git repository
        When the Nix wrapper is generated with offline binaries
        Then the Nix wrapper launches Nix without root
