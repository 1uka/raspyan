#!/bin/bash

if ! command -v qemu-system-arm >/dev/null 2>&1; then
    echo "qemu-system-arm could not be found"
    exit 1
fi

qemu-system-arm -M versatilepb -kernel output/images/zImage -dtb output/images/versatile-pb.dtb -drive file=output/images/rootfs.ext2,if=scsi,format=raw -append "rootwait root=/dev/sda console=ttyAMA0,115200" -serial stdio -net nic,model=rtl8139 -net user
