#!/bin/bash

# This script creates a mash sketch library using RefSeq genomes
# RefSeq genomes can be downloaded using the script download_refseq_genomes.sh

NCPUS=24

REFSEQ_VERSION=216

BASE_DIR='/fastdata/db'

# Directory containing RefSeq genomes (input)
REFSEQ_DIR="${BASE_DIR}/RefSeq${REFSEQ_VERSION}"

# File where paths to individual genome fasta files will be stored (output)
REFSEQ_LIST="${BASE_DIR}/refseq_${REFSEQ_VERSION}_fnames.txt"

# k-mer size and sketch sizr
K=21
S=1000

# Mash sketch library (output)
MSHLIB="${BASE_DIR}/refseq_${REFSEQ_VERSION}_k${K}_s${S}.msh"


# Get paths to genomes
find ${REFSEQ_DIR} -name "*.fna.gz" | sort -V > ${REFSEQ_LIST}

# Create mash sketch
mash sketch \
-k ${K} \
-s ${S}	\
-p ${NCPUS} \
-o $MSHLIB \
-l ${REFSEQ_LIST}
