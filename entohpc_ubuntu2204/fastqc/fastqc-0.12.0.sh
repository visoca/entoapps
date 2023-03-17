#!/bin/bash

# Load entorepo bashrc
source /opt/entorepo/.bashrc

CURRDIR=$PWD
rm -rf fastqc_v0.12.0.zip FastQC >& /dev/null

wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.0.zip
unzip fastqc_v0.12.0.zip

rm -rf /opt/entorepo/apps/fastqc/0.12.0 >& /dev/null
mkdir -p /opt/entorepo/apps/fastqc/0.12.0
cd FastQC
cp -r * /opt/entorepo/apps/fastqc/0.12.0/

cd /opt/entorepo/apps/fastqc
ln -sTf 0.12.0 current

chmod +x /opt/entorepo/apps/fastqc/current/fastqc
ln -sf /opt/entorepo/apps/fastqc/current/fastqc /opt/entorepo/bin

cd $CURRDIR
rm -rf fastqc_v0.12.0.zip FastQC

