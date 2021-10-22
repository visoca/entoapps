#!/bin/bash
# (c) Victor Soria-Carrasco
# victor.soria.carrasco@gmail.com
# Last modified: 01/10/2017 02:37:44

# Description:
# Retrieve accessions from EBI ENA or NCBI SRA and convert them to fastq format
# (bzip2 or gzip compressed)

# Changelog:
# - 15/08/2017 - Fixed some bugs related to renaming sequences downloaded from NCBI;
#                Added option to extract from SRA third fq file with unpaired reads.
# - 28/09/2017 - Fixed bug related to downloading sequences from EBI. Fixed bug
#                related to cleaning intermediate files
# ToDo:
# - parallelize fastq-dump 

VERSION='0.92-2017.10.01'

ASCP='/usr/local/extras/Genomics/apps/aspera-connect/current/bin/ascp'
WGET='wget'
ASPERAKEY='/usr/local/extras/Genomics/apps/aspera-connect/current/etc/asperaweb_id_dsa.openssh'
FQDUMP='/usr/local/extras/Genomics/apps/ncbi-sratoolkit/current/bin/fastq-dump'

MAXASCPTRANSFER="400m" # ascp target transfer rate
NTHREADS=1 # number of threads for compression
NTHREADSC=4 # number of threads for compression

function author {
	echo
	echo "#########################################"
	echo "  $(basename $0)"
	echo "  version $VERSION"
	echo "  (c) Victor Soria-Carrasco"
	echo "  victor.soria.carrasco@gmail.com"
	echo "#########################################"
	echo
}

function usage {
	echo
	echo "Usage:"
	echo "  $(basename $0)"
	echo "      -i <accession numbers> => SRA run accession numbers separated by commas (e.g. ERR392011,SRR1552375)"
	echo "      -f <file with accession numbers> => file with SRA accesion numbers and optionally new ids for "
	echo "                                          samples on a second column (separated by tabs)"
	echo "      -o <output directory> => Output folder to save fastq files"
	echo "      -db <ebi|ncbi> => optional, retrieve sequences from EBI ENA or NCBI SRA (default=ebi)"
	echo "      -tr <aspera|ftp> => optional, retrieve sequences using aspera connect or wget on FTP (only for EBI ENA, default=aspera)"
	echo "      -fq <gz|bz2> => optional, convert to compressed fastq (default=bz2)"
	echo "      -nt <# threads> => optional, number of threads for parallel processing of accessions (default=1)"
	echo "      -ntc <# threads> => optional, number of threads for compression (default=4)"
	echo "      -k => optional, keep intermediate files (default=clean all except fastq files)"
	echo "      -h => show this help"
	echo ""
	echo "  Examples:"
	echo "      $(basename $0) -i accn -o outdir"
	echo "      $(basename $0) -f accn.dsv -o outdir"
	echo ""
	echo ""
	exit 0
}

author

DB="EBI"
TR="ASPERA"
FQTYPE="bz2"
KEEP=0
if [ "$#" -ge "4" ]; # min 4 args: 2 for -i <accession numbers> (or -f <file with list of accn>), 2 for -o <output directory>
then 
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|-help) usage
					  ;;
			-i)	shift
				ACCNS=$1
				;;
			-f)	shift
				ACCNSFILE=$(readlink -f $1)
				;;
			-o)	shift
				OUTDIR=$(readlink -f $1)
				;;
			-db)shift
				DB=${1^^}
				;;
			-tr)shift
				TR=${1^^}
				;;
			-fq)shift
				FQTYPE=$1
				;;
			-nt)shift
				NTHREADS=$1
				;;
			-ntc)shift
				NTHREADSC=$1
				;;
			-k)	KEEP=1
				;;
			-h)	shift
				usage
				;;	
			*)	echo 
				echo "ERROR - Invalid option: $1"
				echo
				usage
				;;
		esac
		shift
	done
else
	usage
fi

GZCOMP="pigz -p $NTHREADSC"
BZCOMP="lbzip2 -n $NTHREADSC"
if [[ $FQTYPE == "gz" ]];
then
	COMP="$GZCOMP -c"
else
	COMP="$BZCOMP -c"
fi

echo

declare -A ACCESSIONSIDS # associative array for new ids
if [[ ! -z "$ACCNS" ]]; # list of accession numbers
then
	echo "List with accessions detected"
	echo
	ACCESSIONS=$(echo $ACCNS | perl -pe 's/\,/\n/g')
elif [[ -e $ACCNSFILE ]]; # file with accession numbers
then
	echo "File with accessions detected ($ACCNSFILE)"
	echo
	while IFS= read -r line;
	do
		if [[ ! -z "$line" ]];
		then
			accn=$(echo -n "$line" | awk '{print $1}')
			id=$(echo -n "$line" | awk '{print $2}')		
			ACCESSIONSIDS["$accn"]="$id"
		fi
	done < $ACCNSFILE
	ACCESSIONS=$(cat $ACCNSFILE | awk '{print $1}')
else
	echo "ERROR: Input file $ACCNSFILE not found"
	echo
	exit 1
fi

# set max bandwidth per transfer according to number of threads
# if [[ $NTHREADS -gt 1 ]];
# then
# 	ASCPTRANSFER=$(perl -e '$t="'$MAXASCPTRANSFER'"; chop($t); $t=($t/'$NTHREADS'); printf "%.0fm", $t;')
# else
# 	ASCPTRANSFER=$MAXASCPTRANSFER
# fi

ASCPTRANSFER=$MAXASCPTRANSFER

mkdir -p $OUTDIR
echo "Output directory: $OUTDIR"
echo

# save associative array to disk for retrieval within functions below
declare -p ACCESSIONSIDS > $OUTDIR/.accessionsids


# export variables for functions below
# .............................................................................
export OUTDIR
export DB
export TR

export ASCP
export ASPERAKEY
export ASCPTRANSFER

export WGET

export FQDUMP
export COMP
export GZCOMP
export FQTYPE
# .............................................................................

# Function to download data from EBI (fastq.gz format) or NCBI (SRA format)
# .............................................................................
function getseq(){
	accn=$1
	echo "Retrieving $accn from $DB... " > $OUTDIR/$accn.ascp.log
	echo -n "started " >> $OUTDIR/$accn.ascp.log
	date >> $OUTDIR/$accn.ascp.log
	echo >> $OUTDIR/$accn.ascp.log

	echo "DB: $DB" >> $OUTDIR/$accn.ascp.log
	if [[ "$DB" == "NCBI" ]];
	then
		REMOTEPATH="anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/${accn:0:3}/${accn:0:6}/$accn/$accn.sra"
		SPECFLAGS=""
	else
		NDIGITS=$(echo -n $accn | perl -pe 's/^[A-Z]+//g;' | wc -c)
		if [[ $NDIGITS -gt 6 ]];
		then
			REMOTEPATH="era-fasp@fasp.sra.ebi.ac.uk:/vol1/fastq/${accn:0:6}/00${accn: -1}/$accn"
			REMOTEPATHFTP="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${accn:0:6}/00${accn: -1}/$accn/*.fastq.gz"
		else
			REMOTEPATH="era-fasp@fasp.sra.ebi.ac.uk:/vol1/fastq/${accn:0:6}/$accn"
			REMOTEPATHFTP="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${accn:0:6}/$accn/*.fastq.gz"
		fi
		SPECFLAGS="-P 33001"
	fi
	
	echo -e "\t$accn"
	mkdir -p $OUTDIR/$accn-logs
	
	if [[ "$DB" == "EBI" && "$TR" == "FTP" ]];
	then
		echo "REMOTEPATH $REMOTEPATHFTP"  >> $OUTDIR/$accn-logs/wget-transfer.log
		for i in $(seq 0 2);
		do
			$WGET -c $REMOTEPATHFTP -P $OUTDIR >> $OUTDIR/$accn-logs/wget-transfer.log 2>&1
			chmod +rw $OUTDIR/$accn* >> $OUTDIR/$accn-logs/wget-transfer.log 2>&1
		done
	else
		echo "REMOTEPATH $REMOTEPATH"  >> $OUTDIR/$accn.ascp.log
		echo "ASCPTRANSFER $ASCPTRANSFER" >> $OUTDIR/$accn.ascp.log

		CHECKFAIL=1
		CHECKPASS=0
		while [[ $CHECKFAIL -gt 0 || $CHECKPASS -eq 0 ]];
		do

			$ASCP \
			$SPECFLAGS -d -L $OUTDIR/$accn-logs\
			-k 2 --file-checksum=md5\
			--policy=fair -l $ASCPTRANSFER -T \
			-i $ASPERAKEY \
			$REMOTEPATH $OUTDIR/ >> $OUTDIR/$accn.ascp.log 2>&1

			sleep $(( ( RANDOM % 20 )  + 1 )) # wait for buffer to be written to disk
			if [[ -e $OUTDIR/$accn-logs/aspera-scp-transfer.log ]];
			then
				CHECKFAIL=$(grep "Source file transfers failed" $OUTDIR/$accn-logs/aspera-scp-transfer.log | tail -n1 | perl -pe 's/.* //g')
				CHECKPASS=$(grep "Source file transfers passed" $OUTDIR/$accn-logs/aspera-scp-transfer.log | tail -n1 | perl -pe 's/.* //g')
			fi
			echo -e "\t\tCHECKFAIL $CHECKFAIL"
			echo -e "\t\tCHECKPASS $CHECKPASS"
			echo -e "\t\t$ASCP $SPECFLAGS -d -L $OUTDIR/$accn-logs -k 2 --file-checksum=md5 --policy=fair -l $ASCPTRANSFER -T -i $ASPERAKEY $REMOTEPATH $OUTDIR/"
		done
	fi

	if [[ "$DB" == "EBI" && "$TR" == "ASPERA" ]];
	then
		mv $OUTDIR/$accn/*.fastq.gz $OUTDIR/
		sleep $(( ( RANDOM % 30 )  + 1 )) # wait for buffer to be written to disk
		rm -rf $OUTDIR/$accn
	fi

	echo >> $OUTDIR/$accn.ascp.log
	echo -n "finished " >> $OUTDIR/$accn.ascp.log
	date >> $OUTDIR/$accn.ascp.log
}

export -f getseq
# .............................................................................

# Function to convert SRA to fastq format
# .............................................................................
function sra2fq(){
	sra=$1
	accn=$(basename $sra | perl -pe 's/\.sra//g')
	LOG=$OUTDIR/$accn.fqdump.log

	echo "Converting $accn..." > $LOG
	echo -n "started " >> $LOG
	date >> $LOG

	source $OUTDIR/.accessionsids
	id=${ACCESSIONSIDS["$accn"]}


	# check if reads are single or paired
	NREADS=$($FQDUMP -X 1 -Z --split-spot $sra 2>/dev/null | awk 'END{print NR/4}')

	if [[ $NREADS == 1 ]]; # single
	then
		if [[ ! -z $id ]]; # change id for this sample
		then
			echo -e "\tSingle reads detected, saving $accn to $id.fq.$FQTYPE..." >> $LOG

			$FQDUMP \
			--defline-seq '@'$id'-$si' \
			--defline-qual "+" \
			--stdout \
			$sra 2> $LOG | \
			$COMP 1> $OUTDIR/$id.fq.$FQTYPE 2>> $LOG
		else
			echo -e "\tSingle reads detected, saving to $accn.fq.$FQTYPE..." >> $LOG

			$FQDUMP \
			--defline-seq '@$ac-$si' \
			--defline-qual "+" \
			--stdout \
			$sra 2> $LOG | $COMP 1> $OUTDIR/$accn.fq.$FQTYPE 2>> $LOG
		fi
	else # paired
		if [[ ! -z $id ]];
		then
			echo -e "\tPaired reads detected, saving $accn to ${id}_1.fq.$FQTYPE, ${id}_2.fq.$FQTYPE, $id.fq.$FQTYPE..." >> $LOG

			$FQDUMP \
			--defline-seq '@'$id'-$si/$ri' \
			--defline-qual "+" \
			--split-3 \
			--outdir $OUTDIR \
			$sra >> $LOG 2>&1
		else
			echo -e "\tPaired reads detected, saving to ${accn}_1.fq.$FQTYPE, ${accn}_2.fq.$FQTYPE, $accn.fq.$FQTYPE..." >> $LOG

			$FQDUMP \
			--defline-seq '@$ac-$si/$ri' \
			--defline-qual "+" \
			--split-3 \
			--outdir $OUTDIR \
			$sra >> $LOG 2>&1
		fi


		# check fastq files are written to disk (10 tries)
		tries=0
		while [[ ! -e "$OUTDIR/${accn}_1.fastq" && ! -e "$OUTDIR/${accn}_1.fastq" && $tries -le 10 ]];
		do
			echo "waiting for buffer... (try #$tries)" >> $LOG
			sleep $(( ( RANDOM % 10 )  + 1 )) # wait a few seconds for buffer to be written to disk
			tries=$(($tries+1))
		done

		# change id if necessary and compress reads 1 fastq file
		if [[ -e "$OUTDIR/${accn}_1.fastq" ]];
		then
			if [[ ! -z $id ]]; # change id for this sample
			then
				$COMP "$OUTDIR/${accn}_1.fastq" > "$OUTDIR/${id}_1.fq.$FQTYPE" 2>> $LOG
			else
				$COMP "$OUTDIR/${accn}_1.fastq" > "$OUTDIR/${accn}_1.fq.$FQTYPE" 2>> $LOG
			fi
		else
			echo "ERROR: Couldn't find fastq file $OUTDIR/${accn}_1.fastq" 2>> $LOG
		fi

		# change id if necessary and compress reads 2 fastq file
		if [[ -e "$OUTDIR/${accn}_2.fastq" ]];
		then
			if [[ ! -z $id ]]; # change id for this sample
			then
				$COMP "$OUTDIR/${accn}_2.fastq" > "$OUTDIR/${id}_2.fq.$FQTYPE" 2>> $LOG
			else
				$COMP "$OUTDIR/${accn}_2.fastq" > "$OUTDIR/${accn}_2.fq.$FQTYPE" 2>> $LOG
			fi
		else
			echo "ERROR: Couldn't find fastq file $OUTDIR/${accn}_2.fastq" 2>> $LOG
		fi

		# change id if necessary and compress unpaired reads fastq file
		if [[ -e "$OUTDIR/$accn.fastq" ]];
		then
			if [[ ! -z $id ]]; # change id for this sample
			then
				$COMP "$OUTDIR/${accn}.fastq" > "$OUTDIR/${id}.fq.$FQTYPE" 2>> $LOG
			else
				$COMP "$OUTDIR/${accn}.fastq" > "$OUTDIR/${accn}.fq.$FQTYPE" 2>> $LOG
			fi
		else
			echo "ERROR: Couldn't find fastq file $OUTDIR/${accn}.fastq" 2>> $LOG
		fi

	fi
	echo -n "finished " >> $LOG
	date >> $LOG
}

export -f sra2fq
# .............................................................................

# Function to change ID of fastq sequences
# .............................................................................
function renameseqfq(){
	fq=$1
	accn=$(basename $fq | perl -pe 's/(\_[1|2])?\.fastq.gz//g')
	suffix=$(basename $fq | perl -pe '/\_([1|2])?\.fastq.gz/; $_=$1;')

	source $OUTDIR/.accessionsids
	id=${ACCESSIONSIDS["$accn"]}
	
	LOG="$OUTDIR/${accn}_${suffix}.fqrename.log"

	echo "$accn=>$id" > $LOG

	if [[ ! -z $id ]];
	then
		echo -e "\t${accn}_${suffix}"
		echo "Renaming ${accn}_${suffix} to ${id}_${suffix}..." >> $LOG
		echo -n "started " >> $LOG
		date >> $LOG

		readindex=""
		if [[ $suffix != "" ]];
		then
			readindex='\/'$suffix
		fi
		$GZCOMP -cd $fq | \
		perl -pe '$c=1+(($.-1)/4); s/^\@'$accn'.*/\@'$id'\-$c'$readindex'/g' | \
		$COMP > "$OUTDIR/${id}_${suffix}.fq.$FQTYPE" 2>> $LOG

		# rm -f $fq

		echo -n "finished " >> $LOG
		date >> $LOG
	fi
}
export -f renameseqfq
# .............................................................................

# Retrieve sra files from EBI or NCBI
# -----------------------------------------------------------------------------
echo
echo "Retrieving files from $DB..."
echo

# parallel -j $NTHREADS getseq ::: $ACCESSIONS # parallel (not worthy really)
echo "$ACCESSIONS" | xargs -I {} -n 1 bash -c 'getseq {}'
# -----------------------------------------------------------------------------


if [[ $DB == "NCBI" ]];
then
	# Convert from sra to fastq in parallel
	# -----------------------------------------------------------------------------
	echo
	echo "Converting SRA files to fq.$FQTYPE..."
	echo
	SRAS=($(ls $OUTDIR/*.sra))

	parallel -j $NTHREADS sra2fq ::: ${SRAS[@]}
	# -----------------------------------------------------------------------------
else
	FQS=($(ls $OUTDIR/*.fastq.gz))
	firstaccn=$(basename ${FQS[0]} | perl -pe 's/(\_[1|2])?\.fastq.gz//g')
	id=${ACCESSIONSIDS["$firstaccn"]}

	if [[ ! -z $id ]];
	then
		# Rename files if necessary
		# -----------------------------------------------------------------------------
		echo
		echo "Renaming ids..."
		echo
		parallel -j $NTHREADS renameseqfq ::: ${FQS[@]}
		# -----------------------------------------------------------------------------
	else
		if [[ $FQTYPE=="bz2" ]];
		then
			# convert from gz to bz2
			for fq in ${FQS[@]};
			do
				echo $fq
				out=$(basename $fq | perl -pe 's/\.fastq\.gz//g')
				LOG="$OUTDIR/$out.fqconvert.log"
				$GZCOMP -cd $fq | \
				$COMP > "$OUTDIR/$out.fq.$FQTYPE" 2>> $LOG
				rm $fq
			done
		fi
	fi
fi

if [[ $KEEP == 0 ]];
then
	rm -rf $OUTDIR/*.sra $OUTDIR/*-logs $OUTDIR/*.fastq $OUTDIR/*.log $OUTDIR/.accessionsids >& /dev/null
fi

echo
echo "Finished. Files saved to $OUTDIR"


