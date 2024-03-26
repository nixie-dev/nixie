![Nixie](https://raw.githubusercontent.com/nixie-dev/nixie/master/.github/logo.svg#gh-light-mode-only)
![Nixie](https://raw.githubusercontent.com/nixie-dev/nixie/master/.github/logo-dark.svg#gh-dark-mode-only)

## DISCLAIMER

Nixie is currently alpha software, provided as-is with no guarantee. The builder and generated scripts are subject to change, and the current feature set is not to be considered final.

---

Nixie is a lightweight solution to ship the [Nix package manager](https://nixos.org) together with a project repository, regardless of host architecture. It leverages a [brand new feature](https://github.com/NixOS/nix/blob/master/doc/manual/src/release-notes/rl-2.10.md) starting with Nix 2.10, which allows the default Nix binary to host a sandboxed Nix store with no privileges.

On macOS, non-root Nix store support is made possible by [fakedir](https://github.com/nixie-dev/fakedir), which is shipped with the script as a Universal library.

## How do I add Nixie to my project?

To "install" Nixie onto your project's Git repository, you need to be running the Nix package manager, preferably with flakes enabled.

<details>

<summary>

### You have flakes enabled
</summary>

You only need to run one command. Make sure your current directory is this of the project you wish to populate.

```sh
nix run github:nixie-dev/nixie
```

</details>

<details>

<summary>

### You don't use flakes
</summary>

In this case, you need to retrieve Nixie manually, either by cloning this repository or adding it as a Nix channel:

#### As a Nix channel

```sh
nix-channel --add https://github.com/nixie-dev/nixie/archive/master.tar.gz nixie
nix-channel --update
nix-env -iA nixie
```

#### By cloning this repository

```sh
git clone https://github.com/nixie-dev/nixie
nix-shell /path/to/cloned/nixie/shell.nix
```

While it is possible to build Nixie directly from this repository, the resulting binary still requires Nix to be available on setup.

Once you have acquired Nixie, simply run `nixie` to automatically configure the repository you're in.

</details>

## What do the generated files mean?

Running the `nix` script at the root of your repository will automatically determine if you have Nix installed or not. If Nix is installed, it will just redirect the call to your system-wide Nix. It's when it is _not installed_ that the magic happens.

Nixie will automatically download a prebuilt static `nix` binary from this repository's CI jobs into your user's cache directory:

On Linux, `~/.cache/nix-static`

On macOS, `~/Library/Caches/nix-static`

Nixie can also build Nix and its dependencies locally from source code, as a fallback on unsupported platforms.

Subsequent calls to the `nix` script will be redirected to that local binary. The name of the repository script determines which Nix command to run: `nix`, `nix-shell`, `nix-env` (unsupported), etc.

---

Tell everyone your project is [![built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
