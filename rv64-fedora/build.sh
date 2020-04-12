#!/usr/bin/env bash
set -euo pipefail;
. "$(dirname "$0")"/../config.sh;

sudo virt-builder \
  --arch riscv64 \
  --size 20G \
  --ssh-inject root:file:"${CONFIG_SSH_KEY}" \
  --format qcow2 --output disk.qcow2 \
  fedora-rawhide-minimal-20200108.n.0
