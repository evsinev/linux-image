set -eux

mkdir -p downloaded
wget -O downloaded/bl1.bin https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/bl1.bin.hardkernel
wget -O downloaded/bl2.bin https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/bl2.bin.hardkernel
wget -O downloaded/u-boot.bin   https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/u-boot.bin.hardkernel
wget -O downloaded/tzsw.bin     https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/tzsw.bin.hardkernel

cd downloaded
wget -c http://cdimage.ubuntu.com/ubuntu-base/releases/14.04/release/ubuntu-base-14.04.5-base-armhf.tar.gz
wget -c http://builder.mdrjr.net/kernel-3.10/00-LATEST/odroidxu3.tar.xz
wget -c http://builder.mdrjr.net/tools/firmware.tar.xz
