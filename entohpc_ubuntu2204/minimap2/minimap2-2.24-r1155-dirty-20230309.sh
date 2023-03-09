#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf minimap2 >& /dev/null

git clone https://github.com/lh3/minimap2
cd minimap2
make -j 12

rm -rf /opt/entorepo/apps/minimap2/2.24-r1155-dirty-20230309 >& /dev/null
mkdir -p /opt/entorepo/apps/minimap2/2.24-r1155-dirty-20230309
cp -r * /opt/entorepo/apps/minimap2/2.24-r1155-dirty-20230309/

cd /opt/entorepo/apps/minimap2
rm current >& /dev/null
ln -sTf 2.24-r1155-dirty-20230309 current

ln -sf /opt/entorepo/apps/minimap2/current/minimap2 /opt/entorepo/bin/

cd $CURRDIR
rm -rf minimap2
