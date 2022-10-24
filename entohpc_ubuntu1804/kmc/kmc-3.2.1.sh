#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf kmc-3.2.1 KMC3.2.1.linux.tar.gz >& /dev/null

mkdir kmc-3.2.1
wget https://github.com/refresh-bio/KMC/releases/download/v3.2.1/KMC3.2.1.linux.tar.gz
tar -xf KMC3.2.1.linux.tar.gz

rm -rf /opt/entorepo/apps/kmc/3.2.1 >& /dev/null
mkdir -p /opt/entorepo/apps/kmc/3.2.1
cp -r * /opt/entorepo/apps/kmc/3.2.1

cd /opt/entorepo/apps/kmc
rm current >& /dev/null
ln -sTf 3.2.1 current
ln -sf /opt/entorepo/apps/kmc/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf kmc-3.2.1 KMC3.2.1.linux.tar.gz

