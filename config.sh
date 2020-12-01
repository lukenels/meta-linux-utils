## Generic configuration for meta-linux-utils

# SSH port to expose
export CONFIG_SSH_PORT=10000

# Memory to use in VM
export CONFIG_MEMORY=4G

# Public key to inject into built vms
export CONFIG_SSH_KEY="${HOME}/.ssh/id_ed25519.pub"

# Path to QEMU repo
export QEMU=${QEMU:-/opt/qemu}

# Path to Linux repo
export LINUX=${LINUX:-$HOME/repo/linux}

