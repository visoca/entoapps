#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf bbmap BBMap_39.01.tar.gz >& /dev/null

wget https://sourceforge.net/projects/bbmap/files/BBMap_39.01.tar.gz
tar -xf BBMap_39.01.tar.gz
cd bbmap/jni
make -f makefile.linux
cd ..

rm -rf /opt/entorepo/apps/bbtools/39.01 >& /dev/null

mkdir -p /opt/entorepo/apps/bbtools/39.01
cp -r * /opt/entorepo/apps/bbtools/39.01/
cd /opt/entorepo/apps/bbtools

rm current >& /dev/null
ln -sTf 39.01 current
ln -sf /opt/entorepo/apps/bbtools/current/*.sh /opt/entorepo/bin/

cd $CURRDIR
rm -rf bbmap BBMap_39.01.tar.gz
