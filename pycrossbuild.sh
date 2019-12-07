#!/bin/bash

# for arm linux: ./pycrossbuild.sh arm-linux gnueabihf /vagrant/python3.7

host_arch=$1
abi=$2
build_output=$3


target_triplet=$host_arch-$abi
build_arch=$(gcc -dumpmachine)

# build Python and Pgen for host first
mkdir -p $HOME/hostpython
./configure --prefix=$HOME/hostpython
make python Parser/pgen
make install

# now cross-compile
make distclean
cat > config.site << EOF
ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no
EOF
CONFIG_SITE=config.site ./configure --enable-shared --prefix=$build_output --host=$target_triplet --build=$build_arch --disable-ipv6

# build
HOSTPYTHON=$HOME/hostpython/python
HOSTPGEN=$HOME/hostpython/Parser/pgen
BLDSHARED="${target_triplet}-gcc -shared"
CROSS_COMPILE=$target_triplet-
CROSS_COMPILE_TARGET=yes
HOSTARCH=$host_arch
BUILDARCH=$build_arch
make
make install

