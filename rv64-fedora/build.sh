#!/bin/sh
sudo virt-builder \
  --arch riscv64 \
  --size 20G \
  --ssh-inject root:file:$HOME/.ssh/id_ed25519.pub \
  --format qcow2 --output disk.qcow2 \
  fedora-rawhide-minimal-20200108.n.0
