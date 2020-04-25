#!/usr/bin/env bash
. $(dirname $0)/../config.sh

$QEMU/aarch64-softmmu/qemu-system-aarch64 \
   -M virt -cpu cortex-a57 -nographic \
   -kernel $LINUX/arch/arm64/boot/Image \
   -device virtio-scsi-pci,id=scsi0 \
   -drive if=none,file=disk.qcow2,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -append "earlycon console=/dev/ttyAMA0 root=/dev/vda4 rw" \
   -netdev user,id=net0,hostfwd=tcp::"${CONFIG_SSH_PORT}"-:22 -device virtio-net-device,netdev=net0 \
   -fsdev local,security_model=mapped,id=fsdev0,path=$LINUX \
   -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
   -m "${CONFIG_MEMORY}"
