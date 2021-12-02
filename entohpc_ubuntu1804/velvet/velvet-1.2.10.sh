#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf velvet >& /dev/null

git clone --recursive https://github.com/dzerbino/velvet.git
cd velvet
make CATEGORIES=4 MAXKMERLENGTH=71 OPENMP=1
mv velveth velveth-k71
mv velvetg velvetg-k71
make clean
make CATEGORIES=4 MAXKMERLENGTH=201 OPENMP=1
mv velveth velveth-k201
mv velvetg velvetg-k201
ln -s velveth-k201 velveth
ln -s velvetg-k201 velvetg

rm -rf /opt/entorepo/apps/velvet/1.2.10 >& /dev/null

mkdir -p /opt/entorepo/apps/velvet/1.2.10
cp -r * /opt/entorepo/apps/velvet/1.2.10

cd /opt/entorepo/apps/velvet/
rm current >& /dev/null
ln -sTf 1.2.10 current

ln -sf /opt/entorepo/apps/velvet/current/velvet* /opt/entorepo/bin/

cd $CURRDIR
rm -rf velvet
