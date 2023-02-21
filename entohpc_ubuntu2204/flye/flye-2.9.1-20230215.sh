#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf Flye >& /dev/null

git clone https://github.com/fenderglass/Flye
cd Flye
make

rm -rf /opt/entorepo/apps/flye/2.9.1-20230215 >& /dev/null
mkdir -p /opt/entorepo/apps/flye/2.9.1-20230215
cp -r * /opt/entorepo/apps/flye/2.9.1-20230215/

cd /opt/entorepo/apps/flye
rm current >& /dev/null
ln -sTf 2.9.1-20230215 current

ln -sf /opt/entorepo/apps/flye/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf Flye
