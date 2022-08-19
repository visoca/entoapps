#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf yak >& /dev/null

git clone https://github.com/lh3/yak
cd yak
make -j 12

rm -rf /opt/entorepo/apps/yak/0.1-r66-dirty >& /dev/null

mkdir -p /opt/entorepo/apps/yak/0.1-r66-dirty
cp -r * /opt/entorepo/apps/yak/0.1-r66-dirty

cd /opt/entorepo/apps/yak/
rm current >& /dev/null
ln -sTf 0.1-r66-dirty current

ln -sf /opt/entorepo/apps/yak/current/yak /opt/entorepo/bin/

cd $CURRDIR
rm -rf yak
