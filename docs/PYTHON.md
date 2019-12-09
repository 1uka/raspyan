# Working with CPython

## Setup

This document assumes the build environment is GNU/Linux.

First, create an empty repository in GitLab, and clone it.
Then, to get the CPython source and set the upstream, do:

```sh
cd cpython
git remote add upstream https://github.com/python/cpython.git
git pull upstream master
```

You would want to work with a stable Python version, so pull the appropriate branch from the upstream:

```sh
git pull upstream 3.8
```

Now push both branches to the repository created in the first step, which by default is set to the `origin` remote:

```sh
git push origin master
git push origin 3.8
```

And that's it. You have a working copy and can go nuts.

## Cross-Compiling

### Dependencies

Prequisites for cross-compiling Python for ARM are:
    - have the appropriate toolchain installed (for ARM Linux this would be `gcc-arm-linux-gnueabihf`)
    - have all the build dependencies installed

The appropriate toolchain for building for ARM Linux can be installed by running:

```bash
sudo apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```

Then, to get all build dependencies if building from a different architecture (i.e. amd64),
you will need to configure multiarch support. To be able to download packages for different architectures,
without it resulting in conflicts between the existing packages already installed, the following changes need to be applied to
`/etc/apt/sources.list`:

1. Replace `deb` with `deb [arch=amd64]` on every line
2. Add the following lines:

   ```bash
   deb [arch=armhf] http://ports.ubuntu.com/ bionic main multiverse restricted universe
   deb [arch=armhf] http://ports.ubuntu.com/ bionic-updates main multiverse restricted universe
   deb-src [arch=armhf] http://ports.ubuntu.com/ bionic main multiverse restricted universe
   deb-src [arch=armhf] http://ports.ubuntu.com/ bionic-updates main multiverse restricted universe
   ```

3. Run `sudo apt update` to fetch the list of packages from the new sources

After updating the sources, the following two commands will install all Python build dependencies:

```bash
sudo apt install libffi-dev:armhf libssl-dev:armhf
sudo apt build-dep python3.8
```

```bash
cat > config.site << EOF
ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no
EOF
```

Add all extra Python libraries from Lib in `Makefile.pre.in` to `LIBSUBDIRS`.

Then, run the `configure` script:

```bash
CONFIG_SITE=config.site ./configure --enable-shared --prefix=/usr --host=arm-linux-gnueabi --build=x86_64-linux-gnu --disable-ipv6
```
