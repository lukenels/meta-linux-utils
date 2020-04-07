#!/bin/sh
. ../config.sh
$QEMU/i386-softmmu/qemu-system-i386 \
	-nographic \
	-kernel ~/repo/linux/arch/x86/boot/bzImage \
	-hda snapshot.img \
	-enable-kvm \
	-append "console=ttyS0 root=/dev/sda rw" \
	-fsdev local,security_model=mapped,id=fsdev0,path=$HOME/repo/linux \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-nic user,model=e1000 \
	-m 2048m


