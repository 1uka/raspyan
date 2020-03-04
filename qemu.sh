#!/bin/bash
#
# Emulate Raspyan using QEMU
#

OUTDIR=./output/images
KERNEL=$OUTDIR/zImage
DTB=$OUTDIR/bcm2709-rpi-2-b.dtb
ROOTFS=$OUTDIR/rootfs.ext2

if ! command -v qemu-system-arm >/dev/null 2>&1; then
    echo "qemu-system-arm could not be found"
    exit 1
elif [ ! -d "$OUTDIR" ]; then
    echo "output/images directory could not be found"
    exit 1
elif [ ! -f "$KERNEL" ]; then
    echo "Kernel zImage could not be found in output directory"
    echo "Should be at: $KERNEL"
    exit 1
elif [ ! -f "$DTB" ]; then
    echo "Device tree blob for RPi2 could not be found"
    echo "Should be at: $DTB"
    exit 1
elif [ ! -f "$ROOTFS" ]; then
    echo "Root filesystem not found"
    echo "Should be at: $ROOTFS"
    exit 1
fi


qemu-system-arm \
    -M raspi2 \
    -m 256 \
    -kernel $KERNEL \
    -dtb $DTB \
    -drive file=$ROOTFS,format=raw,id=sd0 \
    -append "root=/dev/mmcblk0 rootwait console=tty1 console=ttyAMA0,115200" \
    -serial stdio \
    -net user \
    -no-reboot
