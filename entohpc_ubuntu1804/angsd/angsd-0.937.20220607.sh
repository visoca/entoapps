#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# Note: requires htslib installed

CURRDIR=$PWD

rm -rf angsd >& /dev/null

git clone https://github.com/angsd/angsd.git;
cd angsd
git clone --recurse-submodules https://github.com/samtools/htslib.git;
cd htslib
make -j
cd ..
make -j

mkdir bin
find . -type f -executable | \
grep -v sh | grep -v htslib | grep -v ".git" | \
xargs -I {} sh -c 'mv {} bin/'
make clean

rm -rf /opt/entorepo/apps/angsd/0.937.20220607 >& /dev/null
mkdir -p /opt/entorepo/apps/angsd/0.937.20220607
cp -r * /opt/entorepo/apps/angsd/0.937.20220607

cd /opt/entorepo/apps/angsd
rm current >& /dev/null
ln -sTf 0.937.20220607 current
ln -sf /opt/entorepo/apps/angsd/current/bin/* /opt/entorepo/bin/

cd $CURRDIR

rm -rf angsd
