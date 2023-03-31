#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf meryl-1.4.tar.xz meryl-1.4 >& /dev/null

wget https://github.com/marbl/meryl/releases/download/v1.4/meryl-1.4.tar.xz
tar -xf meryl-1.4.tar.xz
cd meryl-1.4/src
make -j12
cd ../build

rm -rf /opt/entorepo/apps/meryl/1.4 >& /dev/null
mkdir -p /opt/entorepo/apps/meryl/1.4

cp -r * /opt/entorepo/apps/meryl/1.4/

cd /opt/entorepo/apps/meryl/
rm current >& /dev/null
ln -sTf 1.4 current

ln -sf /opt/entorepo/apps/meryl/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf meryl-1.4.tar.xz meryl-1.4
