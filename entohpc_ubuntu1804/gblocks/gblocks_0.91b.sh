#!/bin/bash

# Load entorepo bashrc
source /opt/entorepo/.bashrc

CURRDIR=$PWD
rm -rf Gblocks_Linux64_0.91b.tar.Z >& /dev/null

wget http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_Linux64_0.91b.tar.Z
tar -xvf Gblocks_Linux64_0.91b.tar.Z

rm -rf /opt/entorepo/apps/gblocks/0.91b >& /dev/null
mkdir -p /opt/entorepo/apps/gblocks/0.91b
cp -r Gblocks_0.91b/* /opt/entorepo/apps/gblocks/0.91b

cd /opt/entorepo/apps/gblocks
ln -sTf 0.91b current

ln -sf /opt/entorepo/apps/gblocks/current/Gblocks /opt/entorepo/bin
ln -sf /opt/entorepo/apps/gblocks/current/Gblocks /opt/entorepo/bin/gblocks

cd $CURRDIR
rm -rf Gblocks_Linux64_0.91b.tar.Z

