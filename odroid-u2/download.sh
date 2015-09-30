cd downloaded
wget -c http://builder.mdrjr.net/kernel-3.8/00-LATEST/odroidu2.tar.xz

# from kernel_update.sh:do_bootloader_update
wget -c -O bl1.bin https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/bl1.HardKernel
wget -c -O bl2.bin https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/bl2.HardKernel
wget -c -O u-boot.bin https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/u-boot.bin.HardKernel
wget -c -O tzsw.bin https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/tzsw.HardKernel

wget -c http://builder.mdrjr.net/tools/firmware.tar.xz

wget -c http://mirror.yandex.ru/ubuntu-cdimage/ubuntu-core/releases/14.04.3/release/ubuntu-core-14.04.3-core-armhf.tar.gz
