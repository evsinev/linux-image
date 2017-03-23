#!/bin/bash

set -eux

DEVICE=/dev/mmcblk1

mount | grep $DEVICE && echo "$DEVICE is mounted" && exit 1

dd if=/dev/zero of=$DEVICE bs=1M count=8

parted /dev/mmcblk1 \
    --align optimal \
    --script \
    mklabel msdos \
    mkpart primary fat32 2MiB  105MiB  \
    mkpart primary linux-swap  105MiB 2048MiB \
    mkpart primary 2048MiB 100% \
    toggle 1 boot \
    print

mkfs.fat  ${DEVICE}p1
mkfs.ext4 ${DEVICE}p3
mkswap    ${DEVICE}p2

mkdir -p rootfs

mount ${DEVICE}p3 rootfs

mkdir -p rootfs/boot

mount ${DEVICE}p1 rootfs/boot


bsdtar -xpf downloaded/ubuntu-base-14.04.5-base-armhf.tar.gz -C rootfs

bsdtar -xpf downloaded/odroidxu3.tar.xz -C rootfs

cp odroidxu3.boot.ini       rootfs/boot/boot.ini
cp shadow                   rootfs/etc/
cp eth0                     rootfs/etc/network/interfaces.d/
cp auto-serial-console.conf rootfs/etc/init/
cp auto-serial-console      rootfs/bin/
#cp ttyUART.conf             rootfs/etc/init/ttyUART.conf
cp sources.list             rootfs/etc/apt/

echo "/dev/mmcblk0p2 swap  swap    defaults  0 0" > /etc/fstab

for i in "# Exynos UART" ttySAC0 ttySAC1 ttySAC2 ttySAC3; do
    echo $i >> rootfs/etc/securetty
done

BLTEMP=./downloaded

# use emmc only if connected to EMMC slot
#signed_bl1_position=0
#bl2_position=30
#uboot_position=62
#tzsw_position=718

# sdcard
signed_bl1_position=1
bl2_position=31
uboot_position=63
tzsw_position=719


dd iflag=dsync oflag=dsync if=$BLTEMP/bl1.bin    of=$DEVICE seek=$signed_bl1_position
dd iflag=dsync oflag=dsync if=$BLTEMP/bl2.bin    of=$DEVICE seek=$bl2_position
dd iflag=dsync oflag=dsync if=$BLTEMP/u-boot.bin of=$DEVICE seek=$uboot_position
dd iflag=dsync oflag=dsync if=$BLTEMP/tzsw.bin   of=$DEVICE seek=$tzsw_position

sync

umount rootfs/boot
umount rootfs

