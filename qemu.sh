#!/bin/bash
#
# Emulate Raspyan using QEMU
#

OUTDIR=./output/images
KERNEL=$OUTDIR/zImage
DTB=$OUTDIR/versatile-pb.dtb
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
    echo "Device tree blob could not be found"
    echo "Should be at: $DTB"
    exit 1
elif [ ! -f "$ROOTFS" ]; then
    echo "Root filesystem not found"
    echo "Should be at: $ROOTFS"
    exit 1
fi


qemu-system-arm \
    -M versatilepb \
    -m 256 \
    -kernel $KERNEL \
    -dtb $DTB \
    -drive file=$ROOTFS,if=scsi,format=raw \
    -append "root=/dev/sda rootwait" \
    -serial stdio \
    -net nic,model=rtl8139 \
    -net user \
    -no-reboot
