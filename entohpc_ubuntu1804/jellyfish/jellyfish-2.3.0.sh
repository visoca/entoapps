#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf jellyfish-2.3.0 jellyfish-2.3.0.tar.gz >& /dev/null

wget https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz
tar -xf jellyfish-2.3.0.tar.gz
cd jellyfish-2.3.0
./configure --pref=/opt/entorepo/apps/jellyfish/2.3.0
make -j 12

rm -rf /opt/entorepo/apps/jellyfish/2.3.0 >& /dev/null
make install

cd /opt/entorepo/apps/jellyfish
rm current >& /dev/null
ln -sTf 2.3.0 current

ln -sf /opt/entorepo/apps/jellyfish/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf jellyfish-2.3.0 jellyfish-2.3.0.tar.gz
