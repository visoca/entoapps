#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf hic_qc >& /dev/null
conda remove -n hic_qc --all

git clone https://github.com/phasegenomics/hic_qc.git
cd hic_qc
conda env create -n hic_qc --file env.yml
conda activate hic_qc
python setup.py install

# wrapper
cat >hic_qc.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate hic_qc

python /opt/entorepo/apps/hic_qc/20230306/hic_qc.py $*

conda deactivate
EOF

chmod +x hic_qc.sh
ln -s hic_qc.sh hic_qc

mkdir -p /opt/entorepo/apps/hic_qc/20230306
cp -r * /opt/entorepo/apps/hic_qc/20230306/
cd /opt/entorepo/apps/hic_qc
rm current >& /dev/null
ln -sTf 20230306 current
ln -sf /opt/entorepo/apps/hic_qc/current/hic_qc /opt/entorepo/bin/

cd $CURRDIR
rm -rf hic_qc
