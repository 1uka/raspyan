#!/bin/sh

BR_RELEASE=$1
BR_CONFIG=$2

echo "Downloading and extracting buildroot ${BR_RELEASE}"
wget -q -c http://buildroot.org/downloads/buildroot-${BR_RELEASE}.tar.gz
tar axf buildroot-${BR_RELEASE}.tar.gz

echo 'Starting buildroot automated kernel build'
cd buildroot-${BR_RELEASE}

if [ -f "$HOME/$BR_CONFIG" ]; then
    cp $HOME/$BR_CONFIG .config
elif [ -f "configs/$BR_CONFIG" ]; then
    make $BR_CONFIG
else
    echo "Invalid configuration file argument: ${BR_CONFIG}"
    exit 1
fi

make
mv output /vagrant/output

echo 'Done. Output from build root can be found at /vagrant/'
