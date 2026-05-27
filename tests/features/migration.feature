Feature: Nixie migrates paths from the rootless Nix store to the system Nix store

    Scenario: Migrate a file
        Given a Git repository
        And a Nix wrapper generated with offline binaries
        When a file is added to the rootless Nix store
        And the Nix wrapper is launched with system Nix
        Then the file should be in the system Nix store
