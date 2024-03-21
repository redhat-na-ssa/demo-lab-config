#!/bin/sh

# shellcheck disable=SC2148,SC3009,SC2086

for node in $(oc get nodes --show-kind --no-headers|awk '/node/{print $1}'); do oc debug $node -- chroot /host wipefs -af /dev/sda; oc debug $node -- chroot /host wipefs -af /dev/nvme0n1; oc debug $node -- chroot /host wipefs -af /dev/nvme1n1; oc debug $node -- chroot /host systemctl poweroff; done
