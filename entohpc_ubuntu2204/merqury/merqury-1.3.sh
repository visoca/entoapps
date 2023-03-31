#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf merqury-1.3.tar.gz merqury-1.3 >& /dev/null

# Install R packages
sudo R -e 'install.packages(c("argparse","ggplot2","scales"))'

wget https://github.com/marbl/merqury/archive/v1.3.tar.gz -O merqury-1.3.tar.gz
tar -zxvf merqury-1.3.tar.gz
cd merqury-1.3


rm -rf /opt/entorepo/apps/merqury/1.3 >& /dev/null
mkdir -p /opt/entorepo/apps/merqury/1.3

cp -r * /opt/entorepo/apps/merqury/1.3/

cd /opt/entorepo/apps/merqury/
rm current >& /dev/null
ln -sTf 1.3 current

ln -sf /opt/entorepo/apps/merqury/current/merqury.sh /opt/entorepo/bin/

cd $CURRDIR
rm -rf merqury-1.3.tar.gz merqury-1.3
