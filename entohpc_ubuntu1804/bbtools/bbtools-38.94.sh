#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf bbmap BBMap_38.94.tar.gz >& /dev/null

wget https://sourceforge.net/projects/bbmap/files/BBMap_38.94.tar.gz
tar -xf BBMap_38.94.tar.gz
cd bbmap/jni
make -f makefile.linux
cd ..

rm -rf /opt/entorepo/apps/bbtools/38.94 >& /dev/null

mkdir -p /opt/entorepo/apps/bbtools/38.94
cp -r * /opt/entorepo/apps/bbtools/38.94/
cd /opt/entorepo/apps/bbtools

rm current >& /dev/null
ln -sTf 38.94 current
ln -sf /opt/entorepo/apps/bbtools/current/*.sh /opt/entorepo/bin/

cd $CURRDIR
rm -rf bbmap BBMap_38.94.tar.gz
