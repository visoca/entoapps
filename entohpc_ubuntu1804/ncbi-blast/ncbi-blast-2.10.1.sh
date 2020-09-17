#!/bin/bash

wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.10.1/ncbi-blast-2.10.1+-x64-linux.tar.gz
tar -xf ncbi-blast-2.10.1+-x64-linux.tar.gz

rm -rf /opt/entorepo/apps/ncbi-blast/2.10.1 >& /dev/null
mkdir -p /opt/entorepo/apps/ncbi-blast/2.10.1
cd ncbi-blast-2.10.1+
cp -r * /opt/entorepo/apps/ncbi-blast/2.10.1/

cd /opt/entorepo/apps/ncbi-blast
ln -sTf 2.10.1 current

ln -sf /opt/entorepo/apps/ncbi-blast/current/bin/* /opt/entorepo/bin

cd $CURRDIR
rm -rf ncbi-blast-2.10.1+-x64-linux.tar.gz ncbi-blast-2.10.1+

