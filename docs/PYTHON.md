# Working with CPython

## Setup

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

CPython includes a `./configure` script to setup the build system. The prequisites for cross-compiling are:
    - have the appropriate toolchain installed (for ARM Linux this would be `gcc-arm-linux-gnueabi`)
    - have all the build dependencies installed

First, create a file named `config.site` with the following contents:

```bash
cat > config.site << EOF
ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no
EOF
```

Then, run the `configure` script:

```bash
CONFIG_SITE=config.site ./configure --host=arm-linux-gnueabi --build=x86_64-linux-gnu --disable-ipv6
```
