#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# requires TBB libraries
# sudo apt-get install libtbb-dev


CURRDIR=$PWD

rm -rf bowtie2-2.4.3 bowtie2-2.4.3.tar.gz >& /dev/null

wget https://github.com/BenLangmead/bowtie2/archive/v2.4.3.tar.gz -O bowtie2-2.4.3.tar.gz
tar -xf bowtie2-2.4.3.tar.gz
cd bowtie2-2.4.3
perl -pe 's/SSE_FLAG\=\-msse2/SSE_FLAG\=\-sse4.2/g' Makefile
make


mkdir bin
mv bowtie2* bin/
make clean
rm -rf /opt/entorepo/apps/bowtie2/2.4.3 >& /dev/null

mkdir -p /opt/entorepo/apps/bowtie2/2.4.3
cp -r * /opt/entorepo/apps/bowtie2/2.4.3/
cd /opt/entorepo/apps/bowtie2
rm current >& /dev/null
ln -sTf 2.4.3 current
ln -sf /opt/entorepo/apps/bowtie2/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf bowtie2-2.4.3 bowtie2-2.4.3.tar.gz
