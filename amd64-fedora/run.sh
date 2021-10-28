#!/bin/sh
. $(dirname $0)/../config.sh

qemu-system-x86_64 \
	-nographic \
	-kernel ~/repo/linux/arch/x86/boot/bzImage \
	-hda disk.qcow2 \
	-enable-kvm \
	-append "console=ttyS0 root=/dev/sda4 rw" \
	-fsdev local,security_model=mapped,id=fsdev0,path="${LINUX}" \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-nic user,model=e1000,hostfwd=tcp::"${CONFIG_SSH_PORT}"-:22  \
	-m 4G -smp 4


