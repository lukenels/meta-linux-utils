#!/usr/bin/env bash
. $(dirname $0)/../config.sh

$QEMU/arm-softmmu/qemu-system-arm \
   -M virt -nographic \
   -kernel $LINUX/arch/arm/boot/zImage \
   -device virtio-scsi-pci,id=scsi0 \
   -drive if=none,file=disk.qcow2,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -append "earlycon console=/dev/ttyPS0 root=/dev/vda3 rw" \
   -netdev user,id=net0,hostfwd=tcp::10000-:22 -device virtio-net-device,netdev=net0 \
   -fsdev local,security_model=mapped,id=fsdev0,path=$LINUX \
   -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
   -m 3G
