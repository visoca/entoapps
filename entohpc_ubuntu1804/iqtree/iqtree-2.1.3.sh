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

rm -rf iqtree2-2.1.3 iqtree2-2.1.3.tar.gz >& /dev/null

wget https://github.com/iqtree/iqtree2/archive/refs/tags/v2.1.3.tar.gz -O iqtree2-2.1.3.tar.gz
tar -xf iqtree2-2.1.3.tar.gz

cd iqtree2-2.1.3/
mkdir build
cd build
cmake -DIQTREE_FLAGS=static-libcxx -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..
make -j

rm -rf /opt/entorepo/apps/iqtree/2.1.3 >& /dev/null

mkdir -p /opt/entorepo/apps/iqtree/2.1.3/bin
cp iqtree2 /opt/entorepo/apps/iqtree/2.1.3/bin
cp -r ../example /opt/entorepo/apps/iqtree/2.1.3/

cd /opt/entorepo/apps/iqtree
rm current >& /dev/null
ln -sTf 2.1.3 current
ln -sf /opt/entorepo/apps/iqtree/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf iqtree2-2.1.3 iqtree2-2.1.3.tar.gz
