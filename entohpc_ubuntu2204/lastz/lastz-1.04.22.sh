#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf lastz-1.04.22.tar.gz lastz-1.04.22 >& /dev/null

wget https://github.com/lastz/lastz/archive/refs/tags/1.04.22.tar.gz -O lastz-1.04.22.tar.gz
tar -xf lastz-1.04.22.tar.gz
cd lastz-1.04.22
make -j 12
LASTZ_INSTALL=$PWD/bin make install

rm -rf /opt/entorepo/apps/lastz/1.04.22 >& /dev/null

mkdir -p /opt/entorepo/apps/lastz/1.04.22
cp -r * /opt/entorepo/apps/lastz/1.04.22
cd /opt/entorepo/apps/lastz
rm current >& /dev/null
ln -sTf 1.04.22 current
ln -sf /opt/entorepo/apps/lastz/current/bin/lastz* /opt/entorepo/bin/

cd $CURRDIR
rm -rf lastz-1.04.22.tar.gz lastz-1.04.22
