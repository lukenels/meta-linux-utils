#!/usr/bin/env bash
set -euo pipefail;
. "$(dirname "$0")"/config.sh;

ssh -p "$CONFIG_SSH_PORT" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 'root@localhost'
