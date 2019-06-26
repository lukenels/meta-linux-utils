#!/bin/sh
qemu-system-i386 \
	-nographic \
	-kernel ~/repo/linux/arch/x86/boot/bzImage \
	-hda snapshot.img \
	-append "console=ttyS0 root=/dev/sda rw" \
	-enable-kvm \
	-fsdev local,security_model=passthrough,id=fsdev0,path=$HOME \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-m 2048m


