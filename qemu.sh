#!/bin/bash

if ! command -v qemu-system-arm >/dev/null 2>&1; then
    echo "qemu-system-arm could not be found"
    exit 1
fi

qemu-system-arm \
    -M raspi2 \
    -m 256 \
    -kernel output/images/zImage \
    -dtb output/images/bcm2709-rpi-2-b.dtb \
    -drive file=output/images/rootfs.ext2,format=raw,id=sd0 \
    -append "root=/dev/mmcblk0 rootwait console=tty1 console=ttyAMA0,115200" \
    -serial stdio \
    -net user \
    -no-reboot
