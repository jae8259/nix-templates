# kernel-mod

Out-of-tree Linux kernel module development environment.

## Setup

```sh
bash setup.sh    # rename the module — must run once
```

`setup.sh` renames `src/module.c`, updates `src/Kbuild`, and updates `GNUmakefile`
to use your chosen name. The default name `module` conflicts with the kernel's own
`/sys/module/module/` subsystem and will be rejected as already loaded on every boot.

## Build

```sh
make        # produces src/<name>.ko
make ccdb   # generate compile_commands.json for clangd
```

## Load / unload (inside QEMU guest or on the target machine)

```sh
make insmod   # sudo insmod src/<name>.ko
make rmmod    # sudo rmmod <name>
make reload   # clean → build → rmmod → insmod → dmesg tail
```

## direnv integration

| Context | How KERNELDIR is set |
|---|---|
| Inside a parent project with its own `.envrc` | `source_up` inherits it automatically |
| Standalone (this directory is the project root) | Run `nix develop` manually |
| macOS | `nix develop` → warns to use Docker or the Ubuntu host |

## Switching kernel version

Change `linuxPackages_6_12` at the top of `flake.nix` to any other
`linuxPackages_*` attribute from nixpkgs. `KERNELDIR` and `KERNELVER` update
automatically on the next `nix develop`.
