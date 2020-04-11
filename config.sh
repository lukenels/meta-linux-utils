## Generic configuration for meta-linux-utils

# SSH port to expose
export CONFIG_SSH_PORT=10000

# Memory to use in VM
export CONFIG_MEMORY=3G

# Path to QEMU repo
export QEMU=${QEMU:-$HOME/repo/qemu}

# Path to Linux repo
export LINUX=${LINUX:-$HOME/repo/linux}

