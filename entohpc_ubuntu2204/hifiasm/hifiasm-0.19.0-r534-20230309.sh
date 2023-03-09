#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf hifiasm >& /dev/null

git clone https://github.com/chhylp123/hifiasm
cd hifiasm
make -j 12

rm -rf /opt/entorepo/apps/hifiasm/0.19.0-r534-20230309 >& /dev/null

mkdir -p /opt/entorepo/apps/hifiasm/0.19.0-r534-20230309
cp -r * /opt/entorepo/apps/hifiasm/0.19.0-r534-20230309

cd /opt/entorepo/apps/hifiasm/
rm current >& /dev/null
ln -sTf 0.19.0-r534-20230309 current

ln -sf /opt/entorepo/apps/hifiasm/current/hifiasm /opt/entorepo/bin/

cd $CURRDIR
rm -rf hifiasm
