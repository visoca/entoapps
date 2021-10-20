#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf mafft-7.487-with-extensions mafft-7.487-with-extensions-src.tgz >& /dev/null

wget https://mafft.cbrc.jp/alignment/software/mafft-7.487-with-extensions-src.tgz
tar -xf mafft-7.487-with-extensions-src.tgz

rm -rf /opt/entorepo/apps/mafft/7.487

cd mafft-7.487-with-extensions/core
make clean
perl -pi -e 's/\/usr\/local/\/opt\/entorepo\/apps\/mafft\/7.487/g' Makefile
make
make install

cd ../extensions
make clean
perl -pi -e 's/\/usr\/local/\/opt\/entorepo\/apps\/mafft\/7.487/g' Makefile
make
make install

cd /opt/entorepo/apps/mafft
rm current >& /dev/null
ln -sTf 7.487 current
ln -sf /opt/entorepo/apps/mafft/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf mafft-7.487-with-extensions mafft-7.487-with-extensions-src.tgz
