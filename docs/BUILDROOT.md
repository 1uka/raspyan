# Configuration File

libc - uClibc-ng
enable PIE/PIC for security
enable link time optimization (LTO) support
password: kernelpy
enable wchar and C++ support for compiler
enable python3
enable opencv3
sqlite
SDL
`make BR2_DEFCONFIG=configs/pykernel_qemu_arm_versatile_defconfig savedefconfig` to save .config

For emulating graphics with qemu, need to configure kernel using `make linux-menuconfig` or manually edit the linux.config file under the qemu board in buildroot
Need to enable the following options:

```env
CONFIG_DRM=y
CONFIG_DRM_VIRTIO_GPU=y
```

Can be found under drivers (just search with '/' when in menuconfig to find the other dependencies and locations)
