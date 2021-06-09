#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf STAR-2.7.9a star-2.7.9a.tar.gz >& /dev/null

wget https://github.com/alexdobin/STAR/archive/2.7.9a.tar.gz -O STAR-2.7.9a.tar.gz
tar -xf STAR-2.7.9a.tar.gz
cd STAR-2.7.9a
rm -rf bin/*
cd source
make clean
make STAR
cp STAR ../bin
make clean
make STARlong
cp STARlong ../bin
make clean
cd ..

rm -rf /opt/entorepo/apps/star/2.7.9a >& /dev/null

mkdir -p /opt/entorepo/apps/star/2.7.9a
cp -r * /opt/entorepo/apps/star/2.7.9a/
cd /opt/entorepo/apps/star
rm current >& /dev/null
ln -sTf 2.7.9a current
ln -sf /opt/entorepo/apps/star/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf STAR-2.7.9a star-2.7.9a.tar.gz
