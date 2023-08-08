#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf hifiasm >& /dev/null

git clone https://github.com/chhylp123/hifiasm
cd hifiasm
make -j 12

rm -rf /opt/entorepo/apps/hifiasm/0.19.5-r593-20230808 >& /dev/null

mkdir -p /opt/entorepo/apps/hifiasm/0.19.5-r593-20230808
cp -r * /opt/entorepo/apps/hifiasm/0.19.5-r593-20230808

cd /opt/entorepo/apps/hifiasm/
rm current >& /dev/null
ln -sTf 0.19.5-r593-20230808 current

ln -sf /opt/entorepo/apps/hifiasm/current/hifiasm /opt/entorepo/bin/

cd $CURRDIR
rm -rf hifiasm
