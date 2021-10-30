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

rm -rf salmon-1.5.2 v1.5.2.tar.gz >& /dev/null

wget https://github.com/COMBINE-lab/salmon/releases/download/v1.5.2/salmon-1.5.2_linux_x86_64.tar.gz
wget https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.5.2.tar.gz
tar -xf v1.5.2.tar.gz
cd salmon-1.5.2/
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/entorepo/apps/salmon/1.5.2 ..
make -j12

rm -rf /opt/entorepo/apps/salmon/1.5.2 >& /dev/null
make install

cd /opt/entorepo/apps/salmon
rm current >& /dev/null
ln -sTf 1.5.2 current

ln -sf /opt/entorepo/apps/salmon/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf salmon-1.5.2 v1.5.2.tar.gz
