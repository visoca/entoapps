#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf juicebox-1.11.08 >& /dev/null

mkdir juicebox-1.11.08
cd juicebox-1.11.08
wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/Juicebox/Juicebox_1.11.08.jar
ln -s Juicebox_1.11.08.jar juicebox.jar

# wrapper
cat > juicebox.sh << 'EOF'
#!/bin/bash

# juicebox tools wrapper

if [[ -z $MEM ]];
then
	MEM=3 # memory in GB
fi

if [ -h $0 ]; then
	DIR=$(dirname $(readlink -m $0))
else
	DIR=$(dirname $0)
fi

echo
echo "This is a wrapper to use juicebox tools with the simple command 'juicebox'."
echo
echo "  Maximum Java heap size (Xmx) set to $MEM""g"
echo "  You can change this value with: MEM=<memory in GB> juicebox <options>"
echo "    example: MEM=6 juicebox "
echo
echo

echo
echo "Maximum Java heap size (Xmx) set to $MEM""g"
echo
java -Xmx"$MEM"g -jar $DIR/juicebox.jar $*

EOF
chmod +x juicebox.sh
ln -s juicebox.sh juicebox

rm -rf /opt/entorepo/apps/juicebox/1.11.08 >& /dev/null

mkdir -p /opt/entorepo/apps/juicebox/1.11.08
cp -r * /opt/entorepo/apps/juicebox/1.11.08
cd /opt/entorepo/apps/juicebox
rm current >& /dev/null
ln -sTf 1.11.08 current
ln -sf /opt/entorepo/apps/juicebox/current/juicebox /opt/entorepo/bin/

cd $CURRDIR
rm -rf juicebox-1.11.08
