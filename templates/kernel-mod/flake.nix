# Usage: nix flake init -t github:YOURNAME/nix-templates#kernel-mod
# Switch kernel version: change linuxPackages_6_12 at the top of this file
# On macOS: KERNELDIR is not set. Use `make docker-build` or the Ubuntu host.
# Inside QEMU guest: KERNELDIR resolves via uname -r (safe here).
{
  description = "Out-of-tree Linux kernel module development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Change this to switch kernel version across the whole flake.
        kernelPackages = pkgs.linuxPackages_6_12;

        pkgs = nixpkgs.legacyPackages.${system};
        isLinux = pkgs.stdenv.isLinux;
        isDarwin = pkgs.stdenv.isDarwin;

        # Packages available on every platform.
        commonPackages = with pkgs; [
          git
          bear
          clang-tools
          docker-client
        ];

        # pwndbg is not in nixpkgs; add it via its own flake if you want it:
        #   inputs.pwndbg.url = "github:pwndbg/pwndbg";
        #   packages = [ inputs.pwndbg.packages.${system}.pwndbg ];
        linuxOnlyPackages = with pkgs; [
          gdb
          qemu
          kmod
          bpftrace
          gcc
          gnumake
        ];

        devShellPackages =
          commonPackages
          ++ (if isLinux then linuxOnlyPackages else [ ]);

        linuxShellHook = ''
          export KERNELDIR="${kernelPackages.kernel.dev}/lib/modules/${kernelPackages.kernel.modDirVersion}/build"
          export KERNELVER="${kernelPackages.kernel.modDirVersion}"
          echo "KERNELDIR=$KERNELDIR"
          echo "KERNELVER=$KERNELVER"
        '';

        darwinShellHook = ''
          echo "WARNING: .ko compilation is not supported on macOS."
          echo "  Option 1: Use 'make docker-build' (requires docker-client above)."
          echo "  Option 2: Work on the Ubuntu host where Nix provides kernel headers."
          echo "  Inside QEMU guest: KERNELDIR resolves via uname -r automatically."
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = devShellPackages;
          shellHook = if isLinux then linuxShellHook else darwinShellHook;
        };
      });
}
