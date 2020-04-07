#!/bin/sh
mkdir -p ~/.config/virt-builder/repos.d/
cat <<EOF >~/.config/virt-builder/repos.d/fedora-riscv.conf
[fedora-riscv]
uri=https://dl.fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/index
EOF
