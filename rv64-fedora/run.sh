#!/usr/bin/env bash
set -euo pipefail;
. "$(dirname "$0")"/../config.sh;

qemu-system-riscv64 \
   -M virt -m 4G -smp 4 -nographic \
   -bios default \
   -kernel $LINUX/arch/riscv/boot/Image \
   -append "console=/dev/hvc0 earlycon root=/dev/vda4 rw" \
   -object rng-random,filename=/dev/urandom,id=rng0 \
   -device virtio-rng-device,rng=rng0 \
   -drive file=disk.qcow2,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -netdev user,id=usernet,hostfwd=tcp::10000-:22 \
   -device virtio-net-device,netdev=usernet \
   -fsdev local,security_model=mapped,id=fsdev0,path=$LINUX/ \
   -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
