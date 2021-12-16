#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# requires TBB libraries
# sudo apt-get install libtbb-dev


CURRDIR=$PWD

rm -rf mummer-4.0.0rc1 mummer-4.0.0rc1.tar.gz >& /dev/null

wget https://github.com/mummer4/mummer/releases/download/v4.0.0rc1/mummer-4.0.0rc1.tar.gz
tar -xf mummer-4.0.0rc1.tar.gz
cd mummer-4.0.0rc1
./configure --prefix=/opt/entorepo/apps/mummer/4.0.0rc1
make -j 12
rm -rf --prefix=/opt/entorepo/apps/mummer/4.0.0rc1
make install

cd /opt/entorepo/apps/mummer
rm current >& /dev/null
ln -sTf 4.0.0rc1 current
ln -sf /opt/entorepo/apps/mummer/current/bin/* /opt/entorepo/bin/

cd $CURRDIR

rm -rf mummer-4.0.0rc1 mummer-4.0.0rc1.tar.gz
