# KERNELDIR: overridden by Nix shellHook on the Ubuntu host.
# The ?= fallback is only trusted inside the QEMU guest where uname -r is correct.
KERNELDIR ?= /lib/modules/$(shell uname -r)/build

# Where the .ko is installed inside the guest (mount the host share here).
HOSTSHARE ?= /hostshare

MODULE := module

.PHONY: all clean ccdb insmod rmmod reload

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)/src modules

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)/src clean

# Generate compile_commands.json for clangd.
ccdb:
	bear -- $(MAKE)

insmod:
	sudo insmod src/$(MODULE).ko

rmmod:
	-sudo rmmod $(MODULE)

# Remove the old module, rebuild, reload, then show the last 20 kernel log lines.
reload: clean all rmmod insmod
	sudo dmesg | tail -20
