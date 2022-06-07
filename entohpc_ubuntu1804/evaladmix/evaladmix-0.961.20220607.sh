#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# Note: requires htslib installed

CURRDIR=$PWD

rm -rf evalAdmix >& /dev/null

git clone https://github.com/GenisGE/evalAdmix.git
cd evalAdmix
make
mkdir bin 
mv evalAdmix bin/
make clean

rm -rf /opt/entorepo/apps/evaladmix/0.961.20220607 >& /dev/null
mkdir -p /opt/entorepo/apps/evaladmix/0.961.20220607
cp -r * /opt/entorepo/apps/evaladmix/0.961.20220607

cd /opt/entorepo/apps/evaladmix
rm current >& /dev/null
ln -sTf 0.961.20220607 current
ln -sf /opt/entorepo/apps/evaladmix/current/bin/* /opt/entorepo/bin/

cd $CURRDIR

rm -rf evalAdmix
