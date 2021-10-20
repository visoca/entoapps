#!/bin/bash

# Load entorepo bashrc
source /opt/entorepo/.bashrc

CURRDIR=$PWD
rm -rf seqkit_linux_amd64.tar.gz seqkit >& /dev/null

wget https://github.com/shenwei356/seqkit/releases/download/v0.13.2/seqkit_linux_amd64.tar.gz

tar -xf seqkit_linux_amd64.tar.gz

rm -rf /opt/entorepo/apps/seqkit/0.13.2 >& /dev/null
mkdir -p /opt/entorepo/apps/seqkit/0.13.2
cp -r seqkit /opt/entorepo/apps/seqkit/0.13.2/

cd /opt/entorepo/apps/seqkit
ln -sTf 0.13.2 current
ln -sf /opt/entorepo/apps/seqkit/current/seqkit /opt/entorepo/bin

cd $CURRDIR
rm -rf seqkit_linux_amd64.tar.gz seqkit

