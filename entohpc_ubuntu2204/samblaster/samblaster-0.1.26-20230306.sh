#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf samblaster >& /dev/null

git clone https://github.com/GregoryFaust/samblaster.git
cd samblaster
make -j 12

rm -rf /opt/entorepo/apps/samblaster/0.1.26-20230306 >& /dev/null

mkdir -p /opt/entorepo/apps/samblaster/0.1.26-20230306
cp -r * /opt/entorepo/apps/samblaster/0.1.26-20230306
cd /opt/entorepo/apps/samblaster
rm current >& /dev/null
ln -sTf 0.1.26-20230306 current
ln -sf /opt/entorepo/apps/samblaster/current/samblaster /opt/entorepo/bin/

cd $CURRDIR
rm -rf samblaster
