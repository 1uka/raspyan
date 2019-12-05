# PyKernel

PyKernel is a minimal embedded linux kernel that boots into the python interpreter, instead of booting into command line.
This is done by replacing the `/sbin/init` executable with the appropriate python interpreter, compiled for the target architecture.

# Build

## Kernel

To get the latest version of Torvald's Linux kernel:
`git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git`

The kernel is built using `buildroot` for simplicity. 

