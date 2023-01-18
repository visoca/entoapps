#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf canu-2.2 canu-2.2.Linux-amd64.tar.xz >& /dev/null

wget https://github.com/marbl/canu/releases/download/v2.2/canu-2.2.Linux-amd64.tar.xz
tar -xvf canu-2.2.Linux-amd64.tar.xz
cd canu-2.2

rm -rf /opt/entorepo/apps/canu/2.2 >& /dev/null
mkdir -p /opt/entorepo/apps/canu/2.2

cp -r * /opt/entorepo/apps/canu/2.2/

cd /opt/entorepo/apps/canu/
rm current >& /dev/null
ln -sTf 2.2 current

ln -sf /opt/entorepo/apps/canu/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf canu-2.2 canu-2.2.Linux-amd64.tar.xz
