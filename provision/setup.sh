#!/bin/sh

echo "Running setup provisioner script"

echo "Editing /etc/apt/sources.list..."
sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list

apt-get -qq update
apt-get -qq purge snapd lxcfs lxd ubuntu-core-launcher snap-confine
apt-get -qq upgrade

echo "Installing buildroot dependencies"
apt-get -qq install build-essential libncurses5-dev \
    git bzr cvs mercurial subversion unzip bc \
    libc6-i386 lib32stdc++6 lib32z1 libffi-dev libssl-dev \
    libc6-armel-cross libc6-dev-armel-cross binutils-multiarch

apt-get -qq autoremove
apt-get -qq clean
update-locale LC_ALL=C

echo "Setup done."
