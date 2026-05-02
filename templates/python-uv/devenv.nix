# Usage: nix flake init -t github:YOURNAME/nix-templates#python-uv
# Nix provides: Python interpreter + uv binary only
# uv owns: venv, packages, pyproject.toml, uv.lock
# Never add python.withPackages — it conflicts with uv's package graph
# To add packages: uv add <package>  (not nix, not pip)
{ pkgs, ... }:

{
  # Nix provides the interpreter so uv resolves to a stable Python version.
  # uv will create and manage the venv; do NOT enable languages.python.venv.
  packages = [ pkgs.python3 ];

  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true; # runs `uv sync` automatically on shell entry
    };
    # venv.enable is intentionally omitted — uv manages the venv
  };

  enterShell = ''
    echo "Python: $(python --version)"
    echo "uv:     $(uv --version)"
  '';
}
