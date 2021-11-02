#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf blat >& /dev/null

rsync -aPvh rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/blat ./
cd blat

rm -rf /opt/entorepo/apps/blat/37x1 >& /dev/null

mkdir -p /opt/entorepo/apps/blat/37x1
cp -r * /opt/entorepo/apps/blat/37x1/
cd /opt/entorepo/apps/blat
rm current >& /dev/null
ln -sTf 37x1 current
ln -sf /opt/entorepo/apps/blat/current/blat /opt/entorepo/bin/

cd $CURRDIR
rm -rf blat
