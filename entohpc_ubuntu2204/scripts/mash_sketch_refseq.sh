#!/bin/bash

# Create mash sketch library using RefSeq genomes

REFSEQ_VERSION=216

BASE_DIR='/fastdata/db'

REFSEQ_DIR="${BASE_DIR}/RefSeq${REFSEQ_VERSION}"
REFSEQ_LIST="${BASE_DIR}/refseq_${REFSEQ_VERSION}_fnames.txt"

NCPUS=24
K=21
S=1000

MSHLIB="${BASE_DIR}/refseq_${REFSEQ_VERSION}_k${K}_s${S}.msh"

# Get paths to genomes
find ${REFSEQ_DIR} -name "*.fna.gz" | sort -V > ${REFSEQ_LIST}

# Get mash sketch
mash sketch \
-k ${K} \
-s ${S}	\
-p ${NCPUS} \
-o $MSHLIB \
-l ${REFSEQ_LIST}
