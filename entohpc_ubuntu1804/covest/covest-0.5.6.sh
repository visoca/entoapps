#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

conda env remove -n covest -y
conda create -n covest python=3.6 -y
conda activate covest
pip install covest

# Fix path to comb
MODELS="/opt/entorepo/apps/anaconda3/2021.05/envs/covest/lib/python3.6/site-packages/covest/models.py"
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

rm -rf /opt/entorepo/apps/covest/0.5.6
mkdir -p /opt/entorepo/apps/covest/0.5.6
mv covest.sh /opt/entorepo/apps/covest/0.5.6/

cd /opt/entorepo/apps/covest
rm current >& /dev/null
ln -sTf 0.5.6 current
ln -sf /opt/entorepo/apps/covest/current/covest.sh /opt/entorepo/bin/covest

