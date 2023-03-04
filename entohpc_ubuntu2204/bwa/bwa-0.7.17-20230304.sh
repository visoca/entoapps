#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf bwa >& /dev/null

git clone https://github.com/lh3/bwa.git
cd bwa
make -j 12

mkdir bin
mv bwa *.pl bin/
make clean
rm -rf /opt/entorepo/apps/bwa/0.7.17-20230304 >& /dev/null

mkdir -p /opt/entorepo/apps/bwa/0.7.17-20230304
cp -r * /opt/entorepo/apps/bwa/0.7.17-20230304
cd /opt/entorepo/apps/bwa
rm current >& /dev/null
ln -sTf 0.7.17-20230304 current
ln -sf /opt/entorepo/apps/bwa/current/bin/bwa /opt/entorepo/bin/

cd $CURRDIR
rm -rf bwa
