#!/bin/sh

PYVERSION=$1
PYTHON=$2

echo 'Cloning cpython from git'
git clone https://github.com/1uka/cpython.git
cd cpython
git checkout pykernel-${PYVERSION}-integration
chmod +x crossbuild.sh
mkdir ${PYTHON}-build
echo 'Building cpython...'
./crossbuild.sh -t arm-linux -a gnueabihf -o /tmp/${PYTHON}-build
mv /tmp/${PYTHON}-build/${PYTHON}-arm-linux-gnueabihf.tar.gz /vagrant/
echo 'Done'
