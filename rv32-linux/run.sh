#!/usr/bin/env bash

. ../config.sh

$QEMU/bin/qemu-system-riscv32 \
   -M virt -nographic \
   -m 2G \
   -bios ./fw_jump.elf \
	-kernel $LINUX/arch/riscv/boot/Image \
   -append "rootwait root=/dev/vda ro" \
   -drive file=$(dirname $0)/rootfs.ext2,format=raw,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -netdev user,id=net0 -device virtio-net-device,netdev=net0 \
   -fsdev local,security_model=passthrough,id=fsdev0,path=/ \
   -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
