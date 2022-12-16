#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# requires TBB libraries
# sudo apt-get install libtbb-dev


CURRDIR=$PWD

rm -rf ont-guppy_6.4.2_linux64.tar.gz ont-guppy >& /dev/null

wget https://cdn.oxfordnanoportal.com/software/analysis/ont-guppy_6.4.2_linux64.tar.gz
tar -xf ont-guppy_6.4.2_linux64.tar.gz
cd ont-guppy

rm -rf /opt/entorepo/apps/guppy/6.4.2 >& /dev/null

mkdir -p /opt/entorepo/apps/guppy/6.4.2
cp -r * /opt/entorepo/apps/guppy/6.4.2/
cd /opt/entorepo/apps/guppy
rm current >& /dev/null
ln -sTf 6.4.2 current
ln -sf /opt/entorepo/apps/guppy/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf ont-guppy_6.4.2_linux64.tar.gz ont-guppy
