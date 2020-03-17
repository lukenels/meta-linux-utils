#!/bin/sh
$HOME/repo/qemu/aarch64-softmmu/qemu-system-aarch64 \
	-nographic \
	-kernel ~/repo/linux/arch/arm64/boot/Image \
	-hda disk.qcow2 \
	-M virt -cpu cortex-a57 \
	-append "earlycon console=ttyAMA0 root=/dev/vda rw" \
	-fsdev local,security_model=mapped,id=fsdev0,path=$HOME/repo/linux \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-nic user \
	-serial mon:stdio \
	-serial file:out.log \
	-m 2048m


