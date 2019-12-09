# PyKernel

A Linux kernel that boots into the Python interpreter.

[Buildroot](https://buildroot.org) is used to simplify the build process of a custom Linux kernel for embedded systems.

## Stuff That Needs to be Done ™

- [x] Download Linux source from kernel.org
- [x] Configure a fork to gitlab.pinet.vpn/pykernel/linux and push the code there
- [x] Fork cpython to gitlab.pinet.vpn/pykernel/cpython
- [ ] Try out buildroot by building and emulating a vanilla kernel (no changes)
- [ ] Add/modify/remove a driver/module
- [ ] Change init app (`/sbin/init`) to something else
- [ ] Change main.c for python if needed, reseach what needs to be done first
- [ ] Add Sentinel application and its dependencies to CPython
- [ ] Modify build dependencies and build CPython with Sentinel

