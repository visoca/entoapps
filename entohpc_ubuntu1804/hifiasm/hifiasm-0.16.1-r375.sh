#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf hifiasm >& /dev/null

git clone https://github.com/chhylp123/hifiasm
cd hifiasm
make -j 12

rm -rf /opt/entorepo/apps/hifiasm/0.16.1-r375 >& /dev/null

mkdir -p /opt/entorepo/apps/hifiasm/0.16.1-r375
cp -r * /opt/entorepo/apps/hifiasm/0.16.1-r375

cd /opt/entorepo/apps/hifiasm/
rm current >& /dev/null
ln -sTf 0.16.1-r375 current

ln -sf /opt/entorepo/apps/hifiasm/current/hifiasm /opt/entorepo/bin/

cd $CURRDIR
rm -rf hifiasm
