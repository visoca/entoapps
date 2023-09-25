#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

R --slave -e 'install.packages(c("minpack.lm", "argparse"))'

rm -rf genomescope2.0 >& /dev/null

git clone https://github.com/tbenavi1/genomescope2.0.git
cd genomescope2.0
Rscript install.R

rm -rf /opt/entorepo/apps/genomescope/2.0-20230925 >& /dev/null
mkdir -p /opt/entorepo/apps/genomescope/2.0-20230925
cp -r * /opt/entorepo/apps/genomescope/2.0-20230925

cd /opt/entorepo/apps/genomescope
rm current >& /dev/null
ln -sTf 2.0-20230925 current

ln -sf /opt/entorepo/apps/genomescope/current/genomescope.R /opt/entorepo/bin/

cd $CURRDIR
rm -rf genomescope2.0
