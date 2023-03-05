#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf mapping_pipeline >& /dev/null

git clone https://github.com/ArimaGenomics/mapping_pipeline
cd mapping_pipeline

rm -rf /opt/entorepo/apps/arima/20230304 >& /dev/null

mkdir -p /opt/entorepo/apps/arima/20230304
cp -r * /opt/entorepo/apps/arima/20230304
cd /opt/entorepo/apps/arima
rm current >& /dev/null
ln -sTf 20230304 current

cd $CURRDIR
rm -rf mapping_pipeline
