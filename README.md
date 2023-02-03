# Nix-wrap, the zero-install dev environment

Nix-wrap is a lightweight solution to ship the [Nix package manager](https://nixos.org) together with a project repository, regardless of host architecture. It leverages a [brand new feature](https://github.com/NixOS/nix/blob/master/doc/manual/src/release-notes/rl-2.10.md) starting with Nix 2.10, which allows the default Nix binary to host a sandboxed Nix store with no privileges.

## How do I install Nix-wrap?

To "install" Nix-wrap onto your project's Git repository, you need to be running the Nix package manager, preferably with flakes enabled.

### You have flakes enabled

You only need to run one command. Make sure your current directory is this of the project you wish to populate.

```sh
nix run github:thesola10/nix-wrap
```

### You don't use flakes

In this case, you need to retrieve Nix-wrap manually, either by cloning this repository or adding it as a Nix channel:

#### As a Nix channel

```sh
nix-channel --add https://github.com/thesola10/nix-wrap/archive/master.tar.gz nix-wrap
nix-channel --update
nix-env -iA nix-wrap
```

#### By cloning this repository

```sh
git clone https://github.com/thesola10/nix-wrap
nix-shell /path/to/cloned/nix-wrap/shell.nix
```

While it is possible to build Nix-wrap directly from this repository, the resulting binary still requires Nix to be available on setup.

Once you have acquired Nix-wrap, simply run `nix-wrap` to automatically configure the repository you're in.

## How do I start using Nix-wrap?

Running the `nix` script at the root of your repository will automatically determine if you have Nix installed or not. If Nix is installed, it will just redirect the call to your system-wide Nix. It's when it is _not installed_ that the magic happens.

Nix-wrap will automatically download a prebuilt static `nix` binary from this repository's CI jobs into your user's cache directory:

On Linux, `~/.cache/nix-static`

On macOS, `~/Library/Caches/nix-static`

Subsequent calls to the `nix` script will be redirected to that local binary. The name of the repository script determines which Nix command to run: `nix`, `nix-shell`, `nix-env` (unsupported), etc.

