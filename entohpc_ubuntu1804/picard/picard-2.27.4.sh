#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf picard-2.27.4 >& /dev/null

mkdir picard-2.27.4
cd picard-2.27.4
wget https://github.com/broadinstitute/picard/releases/download/2.27.4/picard.jar

# wrapper
cat > picard.sh << 'EOF'
#!/bin/bash

# Picard tools wrapper

# $1 -> picard tool (name jar file)
# $2 .. $n -> rest of arguments


# export LD_LIBRARY_PATH=/usr/local/extras/Genomics/apps/java/current/lib:$LD_LIBRARY_PATH

if [[ -z $MEM ]];
then
	MEM=3 # memory in GB
fi

if [ -h $0 ]; then
	DIR=$(dirname $(readlink -m $0))
else
	DIR=$(dirname $0)
fi

if [[ $# -eq 0 || $1 == "-h" || $1 == "--help" || $1 == "-help" ]]; then
	echo
	echo "This is a wrapper to use picard tools with the simple command 'picard'."
	echo
	echo "  Maximum Java heap size (Xmx) set to $MEM""g"
	echo "  You can change this value with: MEM=<memory in GB> picard <options>"
	echo "    example: MEM=6 picard MarkDuplicates I=in.bam O=out.bam M=markdupmetrics.txt"
	echo
	echo "Usage: picard <picard tool> <arguments>"
	echo
	echo "Available tools:"
	echo
	java -jar $DIR/picard.jar -h |& grep -vP "USAGE|Available"
	echo
	exit
fi


CHK=$(java -jar picard.jar $1 |& grep -ch "not a valid command")
if [ $CHK -eq 1 ]; then
	echo
	echo "$1 is not a picard tool! Use 'picard -h' to see available tools."
	echo
	exit
fi

echo
echo "Maximum Java heap size (Xmx) set to $MEM""g"
echo
java -Xmx"$MEM"g -jar $DIR/picard.jar $*

EOF
chmod +x picard.sh
ln -s picard.sh picard


rm -rf /opt/entorepo/apps/picard/2.27.4 >& /dev/null

mkdir -p /opt/entorepo/apps/picard/2.27.4
cp -r * /opt/entorepo/apps/picard/2.27.4
cd /opt/entorepo/apps/picard
rm current >& /dev/null
ln -sTf 2.27.4 current
ln -sf /opt/entorepo/apps/picard/current/picard /opt/entorepo/bin/

cd $CURRDIR
rm -rf picard-2.27.4
