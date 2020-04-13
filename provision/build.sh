#!/bin/sh

BR2_DEFCONFIG=$1

echo "Starting Raspyan build"

if [ ! -d "/vagrant/buildroot" ]; then
    echo "Buildroot must be present at shared folder root! (/vagrant/buildroot)"
    exit 1
fi

echo "Copying buildroot directory from shared folder to $HOME/buildroot..."
cp -R /vagrant/buildroot $HOME/buildroot

cd $HOME/buildroot

if [ ! -f "configs/$BR2_DEFCONFIG" ]; then
    echo "Buildroot configuration file 'configs/${BR2_DEFCONFIG}' does not exist!"
    exit 1
fi

echo "Starting buildroot build process"
echo "Buildroot configuration file: 'configs/${BR2_DEFCONFIG}'"
tstart=`date +%s`

make $BR2_DEFCONFIG
make

tar -czf /vagrant/raspyan-build-`date +%Y.%m.%d`.tar.gz output/images/

tend=`date +%s`
runtime=$((tend - tstart))

echo "Build finished."
echo "Time elapsed: ${runtime} seconds"
echo "Output from build root can be found at /vagrant/output"
