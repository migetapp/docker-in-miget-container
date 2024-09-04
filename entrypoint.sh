#!/bin/sh

if [[ $(df -PT /var/lib/docker | awk 'NR==2 {print $2}') == virtiofs ]]; then 
  apk add e2fsprogs
  truncate -s 3G /data/disk.img
  mkfs.ext4 /data/disk.img
  mount /data/disk.img /var/lib/docker; 
fi

dockerd-entrypoint.sh
