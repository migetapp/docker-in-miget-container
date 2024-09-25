#!/bin/sh

# create disk.img
if [ ! -f /data/disk.img ]; then
  total_space=$(df --output=size /data | tail -n 1)
  total_space_gb=$(echo "($total_space / 1024 / 1024) + 0.5" | bc)
  total_space_gb_int=$(printf "%.0f" "$total_space_gb")
  apk add e2fsprogs
  truncate -s "$((total_space_gb_int - 1))G" /data/disk.img
  mkfs.ext4 /data/disk.img
fi

# mount disk.img
mount /data/disk.img /var/lib/docker;

dockerd-entrypoint.sh
