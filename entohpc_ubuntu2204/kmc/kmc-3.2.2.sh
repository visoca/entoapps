#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf kmc-3.2.2 KMC3.2.2.linux.tar.gz >& /dev/null

mkdir kmc-3.2.2
cd kmc-3.2.2
wget https://github.com/refresh-bio/KMC/releases/download/v3.2.2/KMC3.2.2.linux.x64.tar.gz
tar -xf KMC3.2.2.linux.x64.tar.gz

rm -rf /opt/entorepo/apps/kmc/3.2.2 >& /dev/null
mkdir -p /opt/entorepo/apps/kmc/3.2.2
cp -r * /opt/entorepo/apps/kmc/3.2.2

cd /opt/entorepo/apps/kmc
rm current >& /dev/null
ln -sTf 3.2.2 current
ln -sf /opt/entorepo/apps/kmc/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf kmc-3.2.2 KMC3.2.2.linux.x64.tar.gz

