Feature: Nixie can generate a Nix script with offline resources

    Scenario: Offline binaries
        Given a Git repository
        When the Nix wrapper is generated with offline binaries
        And the Nix wrapper is extracted
        Then the Nix wrapper should contain these files
            | filename                |
            | nix.Linux.x86_64        |
            | nix.Darwin.x86_64       |
            | nix.Linux.aarch64       |
            | nix.Darwin.aarch64      |
            | libfakedir.dylib        |

    Scenario: Offline sources
        Given a Git repository
        When the Nix wrapper is generated with offline sources
        And the Nix wrapper is extracted
        Then the Nix wrapper should contain these files
            | filename                |
            | libbrotlicommon         |
            | libsodium               |
            | libeditline             |
            | libarchive              |
            | boost                   |
            | lowdown                 |
            | nix                     |
            | nlohmann_json           |
            | openssl                 |
