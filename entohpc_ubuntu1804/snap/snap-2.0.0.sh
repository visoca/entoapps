#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf snap >& /dev/null
git clone https://github.com/amplab/snap.git
cd snap
make -j12

rm -rf /opt/entorepo/apps/snap/2.0.0 >& /dev/null

mkdir -p /opt/entorepo/apps/snap/2.0.0
cp -r * /opt/entorepo/apps/snap/2.0.0/
cd /opt/entorepo/apps/snap
rm current >& /dev/null
ln -sTf 2.0.0 current
ln -sf /opt/entorepo/apps/snap/current/snap-aligner /opt/entorepo/bin/

cd $CURRDIR
rm -rf snap
