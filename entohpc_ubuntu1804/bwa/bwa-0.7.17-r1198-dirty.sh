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
rm -rf /opt/entorepo/apps/bwa/0.7.17-r1198-dirty. >& /dev/null

mkdir -p /opt/entorepo/apps/bwa/0.7.17-r1198-dirty
cp -r * /opt/entorepo/apps/bwa/0.7.17-r1198-dirty
cd /opt/entorepo/apps/bwa
rm current >& /dev/null
ln -sTf 0.7.17-r1198-dirty current
ln -sf /opt/entorepo/apps/bwa/current/bin/bwa /opt/entorepo/bin/

cd $CURRDIR
rm -rf bwa
