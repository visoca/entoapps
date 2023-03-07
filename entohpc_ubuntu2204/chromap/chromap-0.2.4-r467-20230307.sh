#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf chromap >& /dev/null

git clone https://github.com/haowenz/chromap.git
cd chromap
make -j12

mkdir -p /opt/entorepo/apps/chromap/0.2.4-r467-20230307
cp -r * /opt/entorepo/apps/chromap/0.2.4-r467-20230307
cd /opt/entorepo/apps/chromap
rm current >& /dev/null
ln -sTf 0.2.4-r467-20230307 current
ln -sf /opt/entorepo/apps/chromap/current/chromap /opt/entorepo/bin/

cd $CURRDIR
rm -rf chromap
