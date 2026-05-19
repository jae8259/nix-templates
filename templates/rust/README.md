# Rust template

Simple Rust starter template with a Nix devshell.

## Includes

- `cargo`
- `rustc`
- `clippy`
- `rustfmt`
- `rust-analyzer`

## Usage

```sh
nix flake init -t github:YOURNAME/nix-templates#rust
direnv allow
cargo run
```

This template is intentionally minimal so you can evolve it as your project grows.
