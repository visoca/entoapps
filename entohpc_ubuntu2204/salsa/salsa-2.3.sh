#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf SALSA >& /dev/null

git clone https://github.com/marbl/SALSA.git
cd SALSA
make -j 12

# wrapper
cat > salsa.sh << 'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

source activate py27

if [ -h $0 ]; then
	DIR=$(dirname $(readlink -m $0))
else
	DIR=$(dirname $0)
fi

python $DIR/run_pipeline.py $*
EOF
chmod +x salsa.sh
ln -s salsa.sh salsa

rm -rf /opt/entorepo/apps/salsa/2.3 >& /dev/null

mkdir -p /opt/entorepo/apps/salsa/2.3
cp -r * /opt/entorepo/apps/salsa/2.3
cd /opt/entorepo/apps/salsa
rm current >& /dev/null
ln -sTf 2.3 current
ln -sf /opt/entorepo/apps/salsa/current/salsa /opt/entorepo/bin/

cd $CURRDIR
rm -rf SALSA
