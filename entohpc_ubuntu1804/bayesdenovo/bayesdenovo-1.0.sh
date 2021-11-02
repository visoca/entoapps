#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf BayesDenovo-v1 BayesDenovo-v1.tar.gz >& /dev/null

wget https://raw.githubusercontent.com/henryxushi/BayesDenovo/main/BayesDenovo-v1.tar.gz
tar -xf BayesDenovo-v1.tar.gz
cd BayesDenovo-v1

rm -rf /opt/entorepo/apps/bayesdenovo/1.0
mkdir -p /opt/entorepo/apps/bayesdenovo/1.0
cp -r * /opt/entorepo/apps/bayesdenovo/1.0/

cd /opt/entorepo/apps/bayesdenovo
rm current >& /dev/null
ln -sTf 1.0 current
ln -sf /opt/entorepo/apps/bayesdenovo/current/BayesDenovo_v1.pl /opt/entorepo/bin/

cd $CURRDIR

rm -rf BayesDenovo-v1 BayesDenovo-v1.tar.gz

