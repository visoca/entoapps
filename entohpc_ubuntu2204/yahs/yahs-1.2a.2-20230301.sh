#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf yahs >& /dev/null

git clone https://github.com/c-zhou/yahs.git
cd yahs
make -j 12

mkdir bin
mv yahs juicer bin/
make clean
rm -rf /opt/entorepo/apps/yahs/1.2a.2-20230301 >& /dev/null

mkdir -p /opt/entorepo/apps/yahs/1.2a.2-20230301
cp -r * /opt/entorepo/apps/yahs/1.2a.2-20230301
cd /opt/entorepo/apps/yahs
rm current >& /dev/null
ln -sTf 1.2a.2-20230301 current
ln -sf /opt/entorepo/apps/yahs/current/bin/yahs /opt/entorepo/bin/

cd $CURRDIR
rm -rf yahs
