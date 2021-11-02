#!/bin/bash

# Load entorepo bashrc
source /opt/entorepo/.bashrc

CURRDIR=$PWD
rm -rf ncbi-blast-2.12.0+-x64-linux.tar.gz ncbi-blast-2.12.0+ >& /dev/null

wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.12.0/ncbi-blast-2.12.0+-x64-linux.tar.gz
tar -xf ncbi-blast-2.12.0+-x64-linux.tar.gz

rm -rf /opt/entorepo/apps/ncbi-blast/2.12.0 >& /dev/null
mkdir -p /opt/entorepo/apps/ncbi-blast/2.12.0
cd ncbi-blast-2.12.0+
cp -r * /opt/entorepo/apps/ncbi-blast/2.12.0/

cd /opt/entorepo/apps/ncbi-blast
ln -sTf 2.12.0 current

ln -sf /opt/entorepo/apps/ncbi-blast/current/bin/* /opt/entorepo/bin

cd $CURRDIR
rm -rf ncbi-blast-2.12.0+-x64-linux.tar.gz ncbi-blast-2.12.0+

