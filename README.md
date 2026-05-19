# nix-templates

A collection of Nix flake templates for bootstrapping development environments. Each template encodes the resolution of a non-obvious tension between competing toolchains so you don't have to rediscover it.

```sh
nix flake init -t github:YOURNAME/nix-templates#<template>
```

# Templates

## kernel-mod

An out-of-tree Linux kernel module development environment with kbuild, clangd, QEMU, and debugging tools.

```sh
nix flake init -t github:YOURNAME/nix-templates#kernel-mod
```

**Package manager: Nix** — the devshell provides gcc, make, kmod, pwndbg, gdb, qemu, bpftrace, bear, and clang-tools.

**The tension:** kbuild needs `KERNELDIR` to point at kernel headers, but the right path differs by context. On a Nix-managed Ubuntu host, headers live in the Nix store at a hash-dependent path, not at `/lib/modules/$(uname -r)/build`. Inside a QEMU guest booted with the custom kernel, `uname -r` is correct and the standard path exists. On macOS, no Linux headers exist at all.

**The resolution:** the Nix `shellHook` exports `KERNELDIR` explicitly from the Nix store on Linux. The `GNUmakefile` uses `KERNELDIR ?= /lib/modules/$(shell uname -r)/build` so the `?=` fallback is only ever evaluated inside the QEMU guest, where it is safe. On macOS the shellHook prints a warning directing you to Docker or the Ubuntu host instead. Kernel version is a single variable at the top of `flake.nix` — change it once to upgrade everything.

## python-uv

A Python development environment using [uv](https://docs.astral.sh/uv/) for package management, delivered via [devenv](https://devenv.sh/).

```sh
nix flake init -t github:YOURNAME/nix-templates#python-uv
```

**Package manager: uv** — uv owns the venv, all packages, `pyproject.toml`, and `uv.lock`. Nix provides only the Python interpreter and the uv binary itself.

**The tension:** Nix and uv both want to control the Python environment. If Nix also manages packages via `python.withPackages`, you get two competing package graphs that interfere with each other. `venv.enable` has the same problem.

**The resolution:** Nix is restricted to supplying `pkgs.python3` and the uv binary. Everything else — the venv, dependency resolution, lockfile — is delegated entirely to uv. `languages.python.uv.sync.enable = true` runs `uv sync` automatically on shell entry so the environment is always up to date. To add a dependency: `uv add <package>`. Never `pip install`, never `nix.withPackages`.

## rust

A simple Rust development environment with Cargo and editor tooling.

```sh
nix flake init -t github:YOURNAME/nix-templates#rust
```

**Package manager: Cargo** — the devshell provides `cargo`, `rustc`, `clippy`, `rustfmt`, and `rust-analyzer`.

**The tension:** you want a Rust toolchain that is easy to start with and consistent across machines, without over-engineering the project before you know what it needs.

**The resolution:** the template keeps the setup intentionally small. Nix pins the base toolchain through the flake input, while Cargo owns the project itself. You get a working `src/main.rs`, `Cargo.toml`, and a devshell with the standard Rust tools, and you can extend it later as your project grows.
