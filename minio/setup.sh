#!/bin/bash

# https://min.io/open-source/download
# arm64

parted /dev/sda mklabel gpt
parted -a optimal /dev/sda mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sda1
mkdir -p /mnt/s3-data
mount /dev/sda1 /mnt/s3-data
echo '/dev/sda1 /mnt/s3-data ext4 defaults 0 2' | tee -a /etc/fstab

mkdir /mnt/s3-data
wget https://dl.min.io/server/minio/release/linux-arm64/minio_20241218131544.0.0_arm64.deb
dpkg -i minio_20241218131544.0.0_arm64.deb
MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=password minio server /mnt/s3-data --console-address ":9001"
