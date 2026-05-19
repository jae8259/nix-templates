{
  description = "Nix flake template registry";

  outputs = _inputs: {
    templates = {
      kernel-mod = {
        path = ./templates/kernel-mod;
        description = "Out-of-tree Linux kernel module development environment (kbuild + QEMU + clangd)";
      };
      python-uv = {
        path = ./templates/python-uv;
        description = "Python development environment using uv for package management (via devenv)";
      };
      rust = {
        path = ./templates/rust;
        description = "Rust development environment with cargo, clippy, rustfmt, and rust-analyzer";
      };
    };
  };
}
