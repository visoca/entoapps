#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# Requires GSL and HDF5
# sudo apt install libgsl-dev hdf5-tools libhdf5-dev

CURRDIR=$PWD

rm -rf entropy_1.2d entropy_1.2d.tar.gz >& /dev/null

wget https://raw.githubusercontent.com/visoca/entorepo/master/entohpc_ubuntu1804/entropy/entropy_1.2d.tar.gz
tar -xf entropy_1.2d.tar.gz
cd entropy_1.2d
./configure CPPFLAGS=-I/usr/include/hdf5/serial
make

rm -rf /opt/entorepo/apps/entropy/1.2d
mkdir -p /opt/entorepo/apps/entropy/1.2d
cp -r * /opt/entorepo/apps/entropy/1.2d/

cd /opt/entorepo/apps/entropy
rm current >& /dev/null
ln -sTf 1.2d current
ln -sf /opt/entorepo/apps/entropy/current/entropy /opt/entorepo/bin/

cd $CURRDIR
rm -rf entropy_1.2d entropy_1.2d.tar.gz
