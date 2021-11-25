#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# Requires updating cmake using kitware repository
# wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
# sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
# sudo apt update
# sudo apt install cmake
# sudo apt-add-repository -r 'deb https://apt.kitware.com/ubuntu/ bionic main'

CURRDIR=$PWD

rm -rf ORNA >& /dev/null

git clone https://github.com/SchulzLab/ORNA
cd ORNA
git submodule init
git submodule update
mkdir build
cd build
cmake ..
make -j12

cd ..
mkdir bin
cp build/bin/ORNA bin/
rm -rf build

rm -rf /opt/entorepo/apps/orna/2.0
mkdir -p /opt/entorepo/apps/orna/2.0
cp -r * /opt/entorepo/apps/orna/2.0/

cd /opt/entorepo/apps/orna
rm current >& /dev/null
ln -sTf 2.0 current

ln -sf /opt/entorepo/apps/orna/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf ORNA
