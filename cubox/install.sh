#!/bin/bash

set -eux

DEVICE=/dev/mmcblk1

dd if=/dev/zero of=$DEVICE bs=1M count=4


echo -e "n\np\n1\n\n\nw\n" | fdisk $DEVICE

mkfs.ext4 ${DEVICE}p1

mkdir -p rootfs

mount ${DEVICE}p1 rootfs

bsdtar -xpf ubuntu-core-14.04.2-core-armhf.tar.gz -C rootfs

bsdtar -xpf linux-imx-3.14.29+.tbz -C rootfs

cp uEnv.txt rootfs/boot/
cp shadow rootfs/etc/
cp eth0 rootfs/etc/network/interfaces.d/

dd if=SPL of=$DEVICE bs=1K seek=1
dd if=u-boot.img of=$DEVICE bs=1K seek=42

sync

umount rootfs
