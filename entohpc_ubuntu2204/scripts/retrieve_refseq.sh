#!/bin/bash
# (c) Victor Soria-Carrasco
# victor.soria.carrasco@gmail.com

# Description:
# Retrieve last release RefSeq complete

ENTOREPO_DB_PATH='/opt/entorepo/db'
REFSEQ_URL='ftp://ftp.ncbi.nlm.nih.gov/refseq/release'
REFSEQ_VERSION=$(curl -s ${REFSEQ_URL}/RELEASE_NUMBER)

echo "Downloading RefSeq release ${REFSEQ_VERSION} complete..."

mkdir -p ${ENTOREPO_DB_PATH}/refseq/${REFSEQ_VERSION}/tmp
cd ${ENTOREPO_DB_PATH}/refseq/${REFSEQ_VERSION}/tmp

wget ${REFSEQ_URL}/complete/*genomic.fna.gz

cat *.fna.gz > ../RefSeq_${REFSEQ_VERSION}.fna.gz

# cd ..
# rm -rf tmp

