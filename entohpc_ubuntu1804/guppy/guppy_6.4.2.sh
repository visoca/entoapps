#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf ont-guppy-cpu_6.4.2_linux64.tar.gz ont-guppy-cpu >& /dev/null

wget https://cdn.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_6.4.2_linux64.tar.gz
tar -xf ont-guppy-cpu_6.4.2_linux64.tar.gz
cd ont-guppy-cpu

rm -rf /opt/entorepo/apps/guppy/6.4.2 >& /dev/null

mkdir -p /opt/entorepo/apps/guppy/6.4.2
cp -r * /opt/entorepo/apps/guppy/6.4.2/
cd /opt/entorepo/apps/guppy
rm current >& /dev/null
ln -sTf 6.4.2 current
ln -sf /opt/entorepo/apps/guppy/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf ont-guppy-cpu_6.4.2_linux64.tar.gz ont-guppy-cpu
