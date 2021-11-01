#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf SPAdes-3.15.3 SPAdes-3.15.3.tar.gz >& /dev/null

wget http://cab.spbu.ru/files/release3.15.3/SPAdes-3.15.3.tar.gz
tar -xzf SPAdes-3.15.3.tar.gz
cd SPAdes-3.15.3

rm -rf /opt/entorepo/apps/spades/3.15.3
PREFIX=/opt/entorepo/apps/spades/3.15.3 ./spades_compile.sh

cd /opt/entorepo/apps/spades
rm current >& /dev/null
ln -sTf 3.15.3 current
ln -sf /opt/entorepo/apps/spades/current/bin/* /opt/entorepo/bin/

cd $CURRDIR

rm -rf SPAdes-3.15.3 SPAdes-3.15.3.tar.gz

