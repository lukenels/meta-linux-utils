#!/usr/bin/env bash

QEMU=$HOME/repo/qemu
LINUX=$HOME/repo/linux

$QEMU/i386-softmmu/qemu-system-i386 \
	-nographic -append 'console=ttyS0' \
	-kernel $LINUX/arch/x86/boot/bzImage \
	-initrd $(dirname $0)/rootfs.cpio \
	-serial mon:stdio \
	-fsdev local,security_model=passthrough,id=fsdev0,path=$HOME \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-enable-kvm
