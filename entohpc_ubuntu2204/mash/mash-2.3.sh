#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf mash-Linux64-v2.3.tar mash-Linux64-v2.3 >& /dev/null

wget https://github.com/marbl/Mash/releases/download/v2.3/mash-Linux64-v2.3.tar
tar -xf mash-Linux64-v2.3.tar
cd mash-Linux64-v2.3

rm -rf /opt/entorepo/apps/mash/2.3 >& /dev/null
mkdir -p /opt/entorepo/apps/mash/2.3
cp -r * /opt/entorepo/apps/mash/2.3

cd /opt/entorepo/apps/mash
rm current >& /dev/null
ln -sTf 2.3 current

ln -sf /opt/entorepo/apps/mash/current/mash /opt/entorepo/bin/

cd $CURRDIR
rm -rf mash-Linux64-v2.3.tar mash-Linux64-v2.3
