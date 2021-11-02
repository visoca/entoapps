#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# requires python igraph
# pip install igraph

CURRDIR=$PWD

rm -rf transabyss-2.0.1.zip transabyss-2.0.1 >& /dev/nulld

wget https://github.com/bcgsc/transabyss/releases/download/2.0.1/transabyss-2.0.1.zip
unzip transabyss-2.0.1.zip
cd transabyss-2.0.1

rm -rf /opt/entorepo/apps/transabyss/2.0.1 >& /dev/null

mkdir -p /opt/entorepo/apps/transabyss/2.0.1
cp -r * /opt/entorepo/apps/transabyss/2.0.1

cd /opt/entorepo/apps/transabyss/
rm current >& /dev/null
ln -sTf 2.0.1 current

ln -sf /opt/entorepo/apps/transabyss/current/transabyss* /opt/entorepo/bin/

cd $CURRDIR
rm -rf transabyss-2.0.1.zip transabyss-2.0.1
