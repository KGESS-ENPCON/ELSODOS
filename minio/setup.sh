#!/bin/bash

echo "Prepare external drives ..."
read -p "Path to external drive (exp. /dev/sda): " DRIVEPATH
read -p "Download-URL for MinIO Server (exp. https://dl.min.io/server/minio/release/linux-arm64/minio_20241218131544.0.0_arm64.deb): " MINIODOWNURL
# https://min.io/open-source/download

parted $DRIVEPATH mklabel gpt
parted -a optimal $DRIVEPATH mkpart primary ext4 0% 100%
mkfs.ext4 $DRIVEPATH1
mkdir -p /mnt/s3-data
mount $DRIVEPATH1 /mnt/s3-data
echo "$DRIVEPATH1 /mnt/s3-data ext4 defaults 0 2" | tee -a /etc/fstab

wget $MINIODOWNURL
dpkg -i minio*

MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=password minio server /mnt/s3-data --console-address ":9001"
