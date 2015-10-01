#!/bin/bash

# apt-get install -y parted dosfstools bsdtar
#echo "uncomment this" && exit 0

DEVICE=/dev/mmcblk1

check_mount() {
    if mount | grep "$DEVICE" ; then 
        echo "$DEVICE is mounted"
        exit 1
    fi
}

create_partitions() {
    check_mount

    dd if=/dev/zero of=$DEVICE bs=1M count=8

    parted /dev/mmcblk1 \
        --align optimal \
        --script \
        mklabel msdos \
        mkpart primary fat32 4MiB  105MiB  \
        mkpart primary linux-swap  105MiB 2048MiB \
        mkpart primary 2048MiB 100% \
        toggle 1 boot \
        print
}

create_fs() {
    check_mount

    mkfs.fat  ${DEVICE}p1
    mkfs.ext4 ${DEVICE}p3
    mkswap    ${DEVICE}p2
}

mount_fs() {

    check_mount

    mkdir -p rootfs

    mount ${DEVICE}p3 rootfs

    mkdir -p rootfs/boot

    mount ${DEVICE}p1 rootfs/boot
}

extract_archives() {
   bsdtar -xpf downloaded/ubuntu-core-14.04.3-core-armhf.tar.gz -C rootfs

   bsdtar -xpf downloaded/odroidu2.tar.xz -C rootfs

   mkdir -p rootfs/lib/firmware
   bsdtar -xpf downloaded/firmware.tar.xz -C rootfs/lib/firmware
}

copy_files() {
cp boot.txt       rootfs/boot/boot.txt
cp config.sh      rootfs/root/config.sh
cp `which mkimage` rootfs/usr/bin/
cp ../odroid-xu4/shadow                   rootfs/etc/
cp ../odroid-xu4/eth0                     rootfs/etc/network/interfaces.d/
cp ../odroid-xu4/auto-serial-console.conf rootfs/etc/init/
cp ../odroid-xu4/auto-serial-console      rootfs/bin/
#cp ttyUART.conf             rootfs/etc/init/ttyUART.conf
cp ../odroid-xu4/sources.list             rootfs/etc/apt/

cp uEnv.txt rootfs/boot/
}

create_files() {

    echo "/dev/mmcblk0p2 swap  swap    defaults  0 0" > /etc/fstab

    for i in "# Exynos UART" ttySAC0 ttySAC1 ttySAC2 ttySAC3; do
        echo $i >> rootfs/etc/securetty
    done
}


install_bootloader() {

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
tzsw_position=2111

dd iflag=dsync oflag=dsync if=$BLTEMP/bl1.bin    of=$DEVICE seek=$signed_bl1_position
dd iflag=dsync oflag=dsync if=$BLTEMP/bl2.bin    of=$DEVICE seek=$bl2_position
dd iflag=dsync oflag=dsync if=$BLTEMP/u-boot.bin of=$DEVICE seek=$uboot_position
dd iflag=dsync oflag=dsync if=$BLTEMP/tzsw.bin   of=$DEVICE seek=$tzsw_position

}

run_config() {
    chroot ./rootfs/ /root/config.sh
}

unmount_fs() {
    sync
    umount rootfs/boot
    umount rootfs
}


run_cache() {
    func=$1

    mkdir -p .cache/
    if [ -f .cache/$func ] ; then
        echo "$func is from cache"
    else
        $func
    fi
    touch .cache/$func
}

set -eux

run_cache create_partitions
run_cache create_fs
run_cache mount_fs
run_cache extract_archives
run_cache copy_files
run_cache create_files
run_cache install_bootloader
run_cache run_config
run_cache unmount_fs
