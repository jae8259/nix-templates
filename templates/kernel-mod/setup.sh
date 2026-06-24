#!/usr/bin/env bash
set -euo pipefail

# Guard: already renamed if src/module.c is gone.
if [ ! -f src/module.c ]; then
  echo "setup.sh: src/module.c not found — already renamed, nothing to do."
  exit 0
fi

echo "Kernel module setup"
echo "-------------------"
echo "The default name 'module' conflicts with the kernel's own /sys/module/module/"
echo "and will be rejected as already loaded on every boot."
echo ""

while true; do
  read -rp "Module name (no spaces, not 'module'): " NAME
  if [ -z "$NAME" ]; then
    echo "  Error: name cannot be empty." >&2
  elif [ "$NAME" = "module" ]; then
    echo "  Error: 'module' is reserved by the kernel." >&2
  elif ! echo "$NAME" | grep -Eq '^[A-Za-z_][A-Za-z0-9_]*$'; then
    echo "  Error: name must be a C identifier: letters, numbers, underscores; not starting with a number." >&2
  else
    break
  fi
done

# Rename source file.
mv src/module.c "src/${NAME}.c"
sed -i "s/LKP: Description of your module/LKP: ${NAME} kernel module/" "src/${NAME}.c"
sed -i "s/module loaded/${NAME} loaded/" "src/${NAME}.c"
sed -i "s/module unloaded/${NAME} unloaded/" "src/${NAME}.c"

# Update Kbuild: obj-m += module.o  →  obj-m += <name>.o
sed -i "s/obj-m += module\.o/obj-m += ${NAME}.o/" src/Kbuild

# Update GNUmakefile: MODULE := module  →  MODULE := <name>
sed -i "s/^MODULE := module$/MODULE := ${NAME}/" GNUmakefile

echo ""
echo "Done. Module renamed to '${NAME}'."
echo ""
echo "Next steps:"
echo "  make          # build ${NAME}.ko"
echo "  make insmod   # load into the running kernel"
echo "  make reload   # clean → build → reload → dmesg"
