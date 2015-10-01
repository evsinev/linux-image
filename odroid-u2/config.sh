#!/bin/bash 

if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]; then
    echo "You are in a host environment. Please run this script in a chroot."
    exit 0
fi

set -eux

export K_VERSION=`ls /boot/config-* | sed s/"-"/" "/g | awk '{printf $2}'`
echo "Version is $K_VERSION"

echo "/dev/root / ext4 rw 0 0" > /etc/mtab
update-initramfs -c -k $K_VERSION
rm /etc/mtab

mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n "uInitrd $K_VERSION" -d /boot/initrd.img-$K_VERSION /boot/uInitrd

mkimage -A arm -T script -C none -n "Boot.scr for odroid-u2" \
        -d /boot/boot.txt /boot/boot.scr
