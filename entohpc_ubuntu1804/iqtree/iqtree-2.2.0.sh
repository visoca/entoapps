#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# requires the following packages in Ubuntu 18.04

# sudo apt install \
# cmake \
# eigen3 \
# libeigen3-dev \
# clang \
# clang-tidy \
# boost \
# libboost-all-dev \
# libc++-dev \
# libc++abi-dev


CURRDIR=$PWD

rm -rf iqtree2-2.2.0 iqtree2-2.2.0.tar.gz >& /dev/null

wget https://github.com/iqtree/iqtree2/archive/refs/tags/v2.2.0.tar.gz -O iqtree2-2.2.0.tar.gz
tar -xf iqtree2-2.2.0.tar.gz

cd iqtree2-2.2.0/
mkdir build
cd build
cmake ..
make -j

rm -rf /opt/entorepo/apps/iqtree/2.2.0 >& /dev/null

mkdir -p /opt/entorepo/apps/iqtree/2.2.0/bin
cp iqtree2 /opt/entorepo/apps/iqtree/2.2.0/bin
cp -r ../example /opt/entorepo/apps/iqtree/2.2.0/

cd /opt/entorepo/apps/iqtree
rm current >& /dev/null
ln -sTf 2.2.0 current
ln -sf /opt/entorepo/apps/iqtree/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf iqtree2-2.2.0 iqtree2-2.2.0.tar.gz
