#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf bwa-mem2 >& /dev/null

git clone --recursive https://github.com/bwa-mem2/bwa-mem2
cd bwa-mem2
make -j 12

mkdir bin
mv bwa-mem2* bin/
make clean
rm -rf /opt/entorepo/apps/bwa-mem2/2.2.1 >& /dev/null

mkdir -p /opt/entorepo/apps/bwa-mem2/2.2.1
cp -r * /opt/entorepo/apps/bwa-mem2/2.2.1
cd /opt/entorepo/apps/bwa-mem2
rm current >& /dev/null
ln -sTf 2.2.1 current
ln -sf /opt/entorepo/apps/bwa-mem2/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf bwa-mem2
