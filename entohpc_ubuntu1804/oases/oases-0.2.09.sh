#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf oases >& /dev/null

git clone --recursive https://github.com/dzerbino/oases
cd oases
make CATEGORIES=4 MAXKMERLENGTH=71 OPENMP=1
mv oases oases-k71
make CATEGORIES=4 MAXKMERLENGTH=201 OPENMP=1
mv oases oases-k201
ln -s oases-k201 oases

perl -pi -e 's/env python/env python2/g' scripts/oases_pipeline.py

rm -rf /opt/entorepo/apps/oases/0.2.09 >& /dev/null

mkdir -p /opt/entorepo/apps/oases/0.2.09
cp -r * /opt/entorepo/apps/oases/0.2.09

cd /opt/entorepo/apps/oases/
rm current >& /dev/null
ln -sTf 0.2.09 current

ln -sf /opt/entorepo/apps/oases/current/oases* /opt/entorepo/bin/
ln -sf /opt/entorepo/apps/oases/current/scripts/oases_pipeline.py /opt/entorepo/bin/

cd $CURRDIR
rm -rf oases
