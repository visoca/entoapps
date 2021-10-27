#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf evigene evigene20may20.tar >& /dev/null

wget https://netactuate.dl.sourceforge.net/project/evidentialgene/evigene20may20.tar

tar -xf evigene20may20.tar
cd evigene

rm -rf /opt/entorepo/apps/evigene/2020-05-20 >& /dev/null

mkdir -p /opt/entorepo/apps/evigene/2020-05-20
cp -r * /opt/entorepo/apps/evigene/2020-05-20/
cd /opt/entorepo/apps/evigene
rm current >& /dev/null
ln -sTf 2020-05-20 current

cd $CURRDIR
rm -rf evigene evigene20may20.tar
