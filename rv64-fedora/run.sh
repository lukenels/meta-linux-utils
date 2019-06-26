#!/usr/bin/env bash

LINUX=${LINUX:-$HOME/repo/linux}
QEMU=${QEMU:-$HOME/repo/qemu}

$QEMU/riscv64-softmmu/qemu-system-riscv64 \
   -M virt -m 4G -smp 4 -nographic \
   -kernel $(dirname $0)/fw_jump.elf \
   -device loader,file=$LINUX/arch/riscv/boot/Image,addr=0x80200000 \
   -append "earlycon console=ttyS0 root=/dev/vda ro" \
   -object rng-random,filename=/dev/urandom,id=rng0 \
   -device virtio-rng-device,rng=rng0 \
   -drive file=$(dirname $0)/stage4-disk.img,format=raw,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -netdev user,id=usernet,hostfwd=tcp::10000-:22 \
   -device virtio-net-device,netdev=usernet \
   -fsdev local,security_model=passthrough,id=fsdev0,path=$LINUX/ \
   -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
