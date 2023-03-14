#!/bin/bash

# This script downloads the latest version of RefSeq genomes
# Be aware downloading all the genomes takes several days

DB_PATH='/fastdata/db'
NCBI_FTP='ftp.ncbi.nlm.nih.gov'
REFSEQ_URL='ftp.ncbi.nlm.nih.gov/refseq/release/'
REFSEQ_GENOMES_URL='ftp.ncbi.nlm.nih.gov/genomes/refseq'
REFSEQ_VERSION=$(curl -s ${REFSEQ_URL}/RELEASE_NUMBER)

echo "Downloading RefSeq release ${REFSEQ_VERSION} genomes..."

REFSEQ_DIR="${DB_PATH}/RefSeq${REFSEQ_VERSION}"

mkdir -p ${REFSEQ_DIR}
cd ${REFSEQ_DIR}

# Download and save genomes from each big group in a separate folder
BIG_GROUPS="archaea bacteria fungi invertebrate mitochondrion plant protozoa vertebrate_mammalian vertebrate_other viral"
for BG in ${BIG_GROUPS};
do
	mkdir ${BG}
	cd ${BG}
	
	wget -c ftp://${REFSEQ_GENOMES_URL}/${BG}/assembly_summary.txt

	grep -v "^#" assembly_summary.txt | cut -f20 | \
	perl -pe 's/https/ftp/g; chomp; @aux=split("\/", $_); $_.="\/$aux[$#aux]"."_genomic.fna.gz\n"' \
	> genomes_paths.txt

	wget -c -i genomes_paths.txt

	#	# rsync - takes too long to get list
	#	grep -v "^#" assembly_summary.txt | cut -f20 | \
	#	perl -pe 's/.*\.nih\.gov\/genomes\///g; chomp; @aux=split("\/", $_); $_.="\/$aux[$#aux]"."_genomic.fna.gz\n"' \
	#	> genomes_paths.txt
	# 
	# 	rsync --no-relative --copy-links --recursive --times --verbose --files-from=genomes_paths.txt rsync://${NCBI_FTP}/genomes ./
	
	cd ..
done

# Plastids
mkdir -p plastid/tmp
wget -c ftp://${REFSEQ_GENOMES_URL}/plastid/*.genomic.fna.gz -P plastid/tmp/
cat plastid/tmp/*.genomic.fna.gz > plastid/plastid.genomic.fna.gz
rm -rf plastid/tmp

# Mitochondria
mkdir -p mitochondrion/tmp
wget -c ftp://${REFSEQ_GENOMES_URL}/mitochondrion/*.genomic.fna.gz -P mitochondrion/tmp/
cat mitochondrion/tmp/*.genomic.fna.gz > mitochondrion/mitochondrion.genomic.fna.gz
rm -rf mitochondrion/tmp

# Plastids
mkdir -p plastid/tmp
wget -c ftp://${REFSEQ_GENOMES_URL}/plastid/*.genomic.fna.gz -P plastid/tmp/
cat plastid/tmp/*.genomic.fna.gz > plastid/plastid.genomic.fna.gz
rm -rf plastid/tmp

