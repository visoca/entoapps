#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf NECAT >& /dev/null

git clone https://github.com/xiaochuanle/NECAT.git
cd NECAT/src
make -j 12
cd ..

rm -rf /opt/entorepo/apps/necat/0.0.1-20230223 >& /dev/null
mkdir -p /opt/entorepo/apps/necat/0.0.1-20230223
cp -r * /opt/entorepo/apps/necat/0.0.1-20230223/

cd /opt/entorepo/apps/necat
rm current >& /dev/null
ln -sTf 0.0.1-20230223 current

ln -sf /opt/entorepo/apps/necat/current/Linux-amd64/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf NECAT
