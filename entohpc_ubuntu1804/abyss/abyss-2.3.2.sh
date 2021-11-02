#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# Requires sparsehash
# apt install libsparsehash-dev

CURRDIR=$PWD

rm -rf abyss-2.3.2 abyss-2.3.2.tar.gz >& /dev/null

wget https://github.com/bcgsc/abyss/releases/download/2.3.2/abyss-2.3.2.tar.gz
tar -xf abyss-2.3.2.tar.gz
cd abyss-2.3.2
./configure --prefix=/opt/entorepo/apps/abyss/2.3.2
make -j12

rm -rf /opt/entorepo/apps/abyss/2.3.2 >& /dev/null
make install

cd /opt/entorepo/apps/abyss
rm current >& /dev/null
ln -sTf 2.3.2 current
ln -sf /opt/entorepo/apps/abyss/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf abyss-2.3.2 abyss-2.3.2.tar.gz
