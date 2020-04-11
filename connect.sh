#!/bin/sh
. $(dirname $0)/config.sh
ssh -p "$SSH_PORT" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 'root@localhost'
