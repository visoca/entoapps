#!/bin/bash

# Load entorepo bashrc
source /opt/entorepo/.bashrc

CURRDIR=$PWD
rm -rf fastqc_v0.11.9.zip FastQC >& /dev/null

wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip

rm -rf /opt/entorepo/apps/fastqc/0.11.9 >& /dev/null
mkdir -p /opt/entorepo/apps/fastqc/0.11.9
cd FastQC
cp -r * /opt/entorepo/apps/fastqc/0.11.9/

cd /opt/entorepo/apps/fastqc
ln -sTf 0.11.9 current

chmod +x /opt/entorepo/apps/fastqc/current/fastqc
ln -sf /opt/entorepo/apps/fastqc/current/fastqc /opt/entorepo/bin

cd $CURRDIR
rm -rf fastqc_v0.11.9.zip FastQC

