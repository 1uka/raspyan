#!/bin/sh

PYTHON=$1

echo "Running setup provisioner script"

echo "Editing /etc/apt/sources.list..."
sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list
sed -i \
    -e 's|^#\?deb-src http://archive.ubuntu.com/ubuntu bionic main restricted|deb-src http://archive.ubuntu.com/ubuntu bionic main restricted|' \
    -e 's|^#\?deb-src http://archive.ubuntu.com/ubuntu bionic universe|deb-src http://archive.ubuntu.com/ubuntu bionic universe|' \
    /etc/apt/sources.list 
sed -i -e 's|^deb |deb \[arch=amd64,i386\] |g' -e 's|^deb-src |deb-src \[arch=amd64,i386\] |g' /etc/apt/sources.list
sed -i \
    -e '$ a deb [arch=armhf] http://ports.ubuntu.com/ bionic main multiverse restricted universe' \
    -e '$ a deb [arch=armhf] http://ports.ubuntu.com/ bionic-updates main multiverse restricted universe' \
    -e '$ a deb-src [arch=armhf] http://ports.ubuntu.com/ bionic main multiverse restricted universe' \
    -e '$ a deb-src [arch=armhf] http://ports.ubuntu.com/ bionic-updates main multiverse restricted universe' \
    /etc/apt/sources.list
dpkg --add-architecture i386
dpkg --add-architecture armhf
apt-get update -qq
apt-get purge -qq snapd lxcfs lxd ubuntu-core-launcher snap-confine
apt-get upgrade -qq

echo "Installing buildroot dependencies"
apt-get install -qq build-essential libncurses5-dev \
    git bzr cvs mercurial subversion unzip bc \
    libc6-i386 lib32stdc++6 lib32z1 \
    libffi-dev libssl-dev ${PYTHON} ${PYTHON}-dev \
    libc6-armel-cross libc6-dev-armel-cross binutils-multiarch \
    binutils-arm-linux-gnueabi gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
echo "Installing CPython build dependencies for armhf"
apt-get install -qq libssl-dev:armhf libffi-dev:armhf \
    liblzma-dev:armhf libbz2-dev:armhf libgdbm-dev:armhf \
    libreadline-dev:armhf libsqlite3-dev:armhf zlib1g-dev:armhf \
    uuid-dev:armhf tk-dev:armhf libncurses5-dev:armhf
apt-get -qq build-dep ${PYTHON}
apt-get -qq build-dep ${PYTHON}:armhf
apt-get -qq autoremove
apt-get -qq clean
update-locale LC_ALL=C

echo "Setup done."
