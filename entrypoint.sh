#!/bin/sh

total_space_kb=$(df -k /data | tail -n 1 | awk '{print $4}')
total_space_mb=$((total_space_kb / 1024))
total_space_gb=$(echo "scale=2; $total_space_mb / 1024" | bc)

image_size_gb=$(echo "$total_space_gb - 0.1" | bc)
image_size_gb_int=$(printf "%.0f" "$image_size_gb")

# Ensure image_size_gb_int is positive
if [ "$image_size_gb_int" -le 0 ]; then
  echo "Insufficient space to create or resize disk.img"
  exit 1
fi

# Create disk.img if it doesn't exist
if [ ! -f /data/disk.img ]; then
  echo "Creating disk.img with size ${image_size_gb_int}G"
  truncate -s "${image_size_gb_int}G" /data/disk.img
  mkfs.ext4 /data/disk.img
else
  # Check current size of disk.img in GB
  current_img_size=$(stat -c%s /data/disk.img)
  current_img_size_gb=$(echo "scale=2; $current_img_size / 1024 / 1024 / 1024" | bc | awk '{printf "%.0f\n", $1}')

  # Resize disk.img only if necessary
  if [ "$image_size_gb_int" -gt "$current_img_size_gb" ]; then
    echo "Resizing disk.img to ${image_size_gb_int}G"
    truncate -s "${image_size_gb_int}G" /data/disk.img
    e2fsck -f /data/disk.img  # Check the filesystem
    resize2fs /data/disk.img   # Resize the filesystem
  else
    echo "No resize needed. Current size: ${current_img_size_gb}G, Desired size: ${image_size_gb_int}G"
  fi
fi

# mount disk.img
mount /data/disk.img /var/lib/docker;

dockerd-entrypoint.sh
