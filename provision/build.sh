#!/bin/sh

DEFCONFIG=$1

echo "Starting pykernel build"

if [ ! -d "/vagrant/buildroot" ]; then
    echo "Buildroot must be present at shared folder root! (/vagrant/buildroot)"
    exit 1
fi

echo "Copying buildroot directory from shared folder to $HOME/buildroot..."
cp -R /vagrant/buildroot $HOME/buildroot

cd $HOME/buildroot
echo 'Starting buildroot build process'
tstart=`date +%s`

make $DEFCONFIG
make

mkdir /vagrant/output
cp -R output/images /vagrant/output/images

tend=`date +%s`
runtime=$((tend - tstart))

echo "Build finished."
echo "Time elapsed: ${runtime} seconds"
echo "Output from build root can be found at /vagrant/output"
