#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf canu >& /dev/null

git clone https://github.com/marbl/canu.git
cd canu/src
make -j 12
cd ../build

rm -rf /opt/entorepo/apps/canu/2.3-dev20230224 >& /dev/null
mkdir -p /opt/entorepo/apps/canu/2.3-dev20230224

cp -r * /opt/entorepo/apps/canu/2.3-dev20230224/

cd /opt/entorepo/apps/canu/
rm current >& /dev/null
ln -sTf 2.3-dev20230224 current

ln -sf /opt/entorepo/apps/canu/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf canu
