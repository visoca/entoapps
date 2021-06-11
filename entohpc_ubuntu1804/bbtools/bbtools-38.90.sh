#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf bbmap BBMap_38.90.tar.gz >& /dev/null

wget https://sourceforge.net/projects/bbmap/files/BBMap_38.90.tar.gz
tar -xf BBMap_38.90.tar.gz
cd bbmap/jni
make -f makefile.linux
cd ..

rm -rf /opt/entorepo/apps/bbtools/38.90 >& /dev/null

mkdir -p /opt/entorepo/apps/bbtools/38.90
cp -r * /opt/entorepo/apps/bbtools/38.90/
cd /opt/entorepo/apps/bbtools

rm current >& /dev/null
ln -sTf 38.90 current
ln -sf /opt/entorepo/apps/bbtools/current/*.sh /opt/entorepo/bin/

cd $CURRDIR
rm -rf bbmap BBMap_38.90.tar.gz
