#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

conda env remove -n covest -y
conda create -n covest python=3.6 -y
conda activate covest
# pip install covest
git clone https://github.com/wernerkrampl/covest
rm -rf /opt/entorepo/apps/covest/0.5.9 >& /dev/null
mkdir -p /opt/entorepo/apps/covest/0.5.9
cd covest
mv * /opt/entorepo/apps/covest/0.5.9/
cd ..
rm -rf covest
cd /opt/entorepo/apps/covest/0.5.9
pip install -e .

# Fix path to comb
MODELS="/opt/entorepo/apps/covest/0.5.9/covest/models.py"
perl -pi -e 's/from scipy\.misc import comb/from scipy\.special import comb/g' $MODELS

# wrapper
cat >covest.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate covest

covest $*

conda deactivate

EOF
chmod +x covest.sh


cd /opt/entorepo/apps/covest
rm current >& /dev/null
ln -sTf 0.5.9 current
ln -sf /opt/entorepo/apps/covest/current/covest.sh /opt/entorepo/bin/covest

