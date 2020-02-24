#!/bin/sh

PYTHON=$1

echo "Running setup provisioner script"

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
apt-get -q update
apt-get purge -q -y snapd lxcfs lxd ubuntu-core-launcher snap-confine
apt-get -q -y upgrade
apt-get -q -y install build-essential libncurses5-dev \
    git bzr cvs mercurial subversion libc6:i386 unzip bc \
    libffi-dev libssl-dev ${PYTHON} ${PYTHON}-dev \
    libc6-armel-cross libc6-dev-armel-cross binutils-multiarch \
    binutils-arm-linux-gnueabi gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
apt-get -q -y install libssl-dev:armhf libffi-dev:armhf \
    liblzma-dev:armhf libbz2-dev:armhf libgdbm-dev:armhf \
    libreadline-dev:armhf libsqlite3-dev:armhf zlib1g-dev:armhf \
    uuid-dev:armhf tk-dev:armhf libncurses5-dev:armhf
apt-get -q -y build-dep ${PYTHON}
apt-get -q -y build-dep ${PYTHON}:armhf
apt-get -q -y autoremove
apt-get -q -y clean
update-locale LC_ALL=C
