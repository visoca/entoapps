#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc
conda activate py36

CURRDIR=$PWD

rm -rf bedtools-2.30.0.tar.gz bedtools2 >& /dev/null

wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz
tar -xf bedtools-2.30.0.tar.gz
cd bedtools2
make -j 12

rm -rf /opt/entorepo/apps/bedtools2/2.30.0 >& /dev/null

mkdir -p /opt/entorepo/apps/bedtools2/2.30.0
cp -r * /opt/entorepo/apps/bedtools2/2.30.0
cd /opt/entorepo/apps/bedtools2
rm current >& /dev/null
ln -sTf 2.30.0 current
ln -sf /opt/entorepo/apps/bedtools2/current/bin/bedtools /opt/entorepo/bin/

cd $CURRDIR
rm -rf bedtools-2.30.0.tar.gz bedtools2
