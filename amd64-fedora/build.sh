#!/bin/sh
sudo virt-builder \
  --arch x86_64 \
  --ssh-inject root:file:$HOME/.ssh/id_ed25519.pub \
  --size 20G --format qcow2 --output disk.qcow2 \
  fedora-34

sudo chown $(whoami) disk.qcow2
