#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf juicer_tools-2.20.00 >& /dev/null

mkdir juicer_tools-2.20.00
cd juicer_tools-2.20.00
wget https://github.com/aidenlab/Juicebox/releases/download/v2.20.00/juicer_tools.2.20.00.jar
ln -s juicer_tools.2.20.00.jar juicer_tools.jar

# wrapper
cat > juicer_tools.sh << 'EOF'
#!/bin/bash

# juicer tools wrapper

# $1 -> juicer tool (name jar file)
# $2 .. $n -> rest of arguments


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
	echo "This is a wrapper to use juicer tools with the simple command 'juicer'."
	echo
	echo "  Maximum Java heap size (Xmx) set to $MEM""g"
	echo "  You can change this value with: MEM=<memory in GB> juicer <options>"
	echo "    example: MEM=6 juicer pre hic-to-contigs.bin scaffolds_final.agp contigs.fa.fai"
	echo
	echo "Usage: juicer <juicer tool> <arguments>"
	echo
	echo "Available tools:"
	echo
	java -jar $DIR/juicer_tools.jar -h |& grep -vP "USAGE|Available"
	echo
	exit
fi


CHK=$(java -jar juicer_tools.jar $1 |& grep -ch "not a valid command")
if [ $CHK -eq 1 ]; then
	echo
	echo "$1 is not a juicer tool! Use 'juicer_tools -h' to see available tools."
	echo
	exit
fi

echo
echo "Maximum Java heap size (Xmx) set to $MEM""g"
echo
java -Xmx"$MEM"g -jar $DIR/juicer_tools.jar $*

EOF
chmod +x juicer_tools.sh
ln -s juicer_tools.sh juicer_tools

rm -rf /opt/entorepo/apps/juicer_tools/2.20.00 >& /dev/null

mkdir -p /opt/entorepo/apps/juicer_tools/2.20.00
cp -r * /opt/entorepo/apps/juicer_tools/2.20.00
cd /opt/entorepo/apps/juicer_tools
rm current >& /dev/null
ln -sTf 2.20.00 current
ln -sf /opt/entorepo/apps/juicer_tools/current/juicer /opt/entorepo/bin/

cd $CURRDIR
rm -rf juicer_tools-2.20.00
