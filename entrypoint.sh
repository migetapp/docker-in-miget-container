#!/bin/sh

# get the size of /data
total_space=$(df --output=size /data | tail -n 1)
total_space_gb=$(echo "($total_space / 1024 / 1024) + 0.5" | bc)
total_space_gb_int=$(printf "%.0f" "$total_space_gb")

# create disk.img or resize disk.img
if [ ! -f /data/disk.img ]; then
  apk add e2fsprogs
  truncate -s "$((total_space_gb_int - 1))G" /data/disk.img
  mkfs.ext4 /data/disk.img
else
  current_size=$(du -BG --apparent-size /data/disk.img | cut -f1 | sed 's/G//')
  desired_img_size=$((total_space_gb_int - 1))
  if [ "$desired_img_size" -gt "$current_size" ]; then
    echo "Resizing disk.img to ${desired_img_size}G"
    truncate -s "${desired_img_size}G" /data/disk.img
    apk add e2fsprogs
    e2fsck -f /data/disk.img
    resize2fs /data/disk.img
  fi
fi

# mount disk.img
mount /data/disk.img /var/lib/docker;

dockerd-entrypoint.sh
