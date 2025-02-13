#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf Flye >& /dev/null

git clone https://github.com/fenderglass/Flye
cd Flye
make

rm -rf /opt/entorepo/apps/flye/2.9.2-20230325 >& /dev/null
mkdir -p /opt/entorepo/apps/flye/2.9.2-20230325
cp -r * /opt/entorepo/apps/flye/2.9.2-20230325/

cd /opt/entorepo/apps/flye
rm current >& /dev/null
ln -sTf 2.9.2-20230325 current

ln -sf /opt/entorepo/apps/flye/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf Flye
