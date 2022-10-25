#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf estpEM_2014-10-08 estpEM_2014-10-08.tar.gz >& /dev/null

wget https://bitbucket.org/visoca/transitions_genomic_differentiation_timema/raw/c662bf2ddeb03f8b4de934d88c4397052c1931f4/fst/estpEM_2014-10-08.tar.gz
tar -xf estpEM_2014-10-08.tar.gz
cd estpEM_2014-10-08
g++ -O3 -o estpEM main.C func.C -lm -lgsl -lgslcblas

rm -rf /opt/entorepo/apps/estpem/0.1-20141008 >& /dev/null

mkdir -p /opt/entorepo/apps/estpem/0.1-20141008
cp -r * /opt/entorepo/apps/estpem/0.1-20141008

cd /opt/entorepo/apps/estpem/
rm current >& /dev/null
ln -sTf 0.1-20141008 current

ln -sf /opt/entorepo/apps/estpem/current/estpEM /opt/entorepo/bin/

cd $CURRDIR
rm -rf estpEM_2014-10-08 estpEM_2014-10-08.tar.gz
