#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf SOAPdenovo-Trans >& /dev/null

git clone --recursive https://github.com/aquaskyline/SOAPdenovo-Trans.git
cd SOAPdenovo-Trans
sh make.sh

rm -rf /opt/entorepo/apps/soapdenovotrans/1.04 >& /dev/null

mkdir -p /opt/entorepo/apps/soapdenovotrans/1.04
cp -r * /opt/entorepo/apps/soapdenovotrans/1.04

cd /opt/entorepo/apps/soapdenovotrans
rm current >& /dev/null
ln -sTf 1.04 current

ln -sf /opt/entorepo/apps/soapdenovotrans/SOAPdenovo-Trans-127mer /opt/entorepo/bin/
ln -sf /opt/entorepo/apps/soapdenovotrans/SOAPdenovo-Trans-31mer /opt/entorepo/bin/

cd $CURRDIR
rm -rf SOAPdenovo-Trans
