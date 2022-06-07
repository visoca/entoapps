#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf stacks-2.61 stacks-2.61.tar.gz >& /dev/null

wget https://catchenlab.life.illinois.edu/stacks/source/stacks-2.61.tar.gz
tar -xf stacks-2.61.tar.gz
cd stacks-2.61
./configure --prefix=/opt/entorepo/apps/stacks/2.61
make -j 12

rm -rf /opt/entorepo/apps/stacks/2.61 >& /dev/null
make install

cd /opt/entorepo/apps/stacks/
rm current >& /dev/null
ln -sTf 2.61 current

ln -sf /opt/entorepo/apps/stacks/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf stacks-2.61 stacks-2.61.tar.gz     
