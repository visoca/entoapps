#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# requires TBB libraries
# sudo apt-get install libtbb-dev


CURRDIR=$PWD

rm -rf bowtie-1.3.1 bowtie-1.3.1.tar.gz >& /dev/null

wget https://github.com/BenLangmead/bowtie/archive/v1.3.1.tar.gz -O bowtie-1.3.1.tar.gz
tar -xf bowtie-1.3.1.tar.gz
cd bowtie-1.3.1
perl -pe 's/SSE_FLAG\=\-msse2/SSE_FLAG\=\-sse4.2/g' Makefile
make


mkdir bin
mv bowtie* bin/
make clean
rm -rf /opt/entorepo/apps/bowtie/1.3.1 >& /dev/null

mkdir -p /opt/entorepo/apps/bowtie/1.3.1
cp -r * /opt/entorepo/apps/bowtie/1.3.1/
cd /opt/entorepo/apps/bowtie
rm current >& /dev/null
ln -sTf 1.3.1 current
ln -sf /opt/entorepo/apps/bowtie/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf bowtie-1.3.1 bowtie-1.3.1.tar.gz
