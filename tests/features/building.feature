Feature: Nixie can build Nix from source code

    Scenario: From source
        Given a Git repository
        When the Nix wrapper is generated with offline sources
        Then the Nix wrapper builds Nix from source
        And the Nix wrapper launches Nix without root
