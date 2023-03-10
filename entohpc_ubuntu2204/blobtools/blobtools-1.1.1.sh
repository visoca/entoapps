#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf blobtools >& /dev/null

git clone https://github.com/DRL/blobtools.git
cd blobtools

conda create -n blobtools -y
conda activate blobtools
conda install -c anaconda matplotlib docopt tqdm wget pyyaml git -y
conda install -c bioconda pysam --update-deps -y 

# wrapper
cat >blobtools.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate blobtools

/opt/entorepo/apps/blobtools/current/blobtools $*

conda deactivate

EOF
chmod +x blobtools.sh

rm -rf /opt/entorepo/apps/blobtools/1.1.1
mkdir -p /opt/entorepo/apps/blobtools/1.1.1
cp -r * /opt/entorepo/apps/blobtools/1.1.1/
mv blobtools.sh /opt/entorepo/apps/blobtools/1.1.1

cd /opt/entorepo/apps/blobtools
rm current >& /dev/null
ln -sTf 1.1.1 current
ln -sf /opt/entorepo/apps/blobtools/current/blobtools.sh /opt/entorepo/bin/blobtools

cd $CURRDIR
rm -rf blobtools
