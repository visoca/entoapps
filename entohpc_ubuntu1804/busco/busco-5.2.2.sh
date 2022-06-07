#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# conda create -n busco -c conda-forge -c bioconda busco=5.2.2

# wrapper
cat >busco.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate busco

/opt/entorepo/apps/anaconda3/2021.05/envs/busco/bin/busco $*

conda deactivate

EOF
chmod +x busco.sh

rm -rf /opt/entorepo/apps/busco/5.2.2
mkdir -p /opt/entorepo/apps/busco/5.2.2
mv busco.sh /opt/entorepo/apps/busco/5.2.2/

cd /opt/entorepo/apps/busco
rm current >& /dev/null
ln -sTf 5.2.2 current
ln -sf /opt/entorepo/apps/busco/current/busco.sh /opt/entorepo/bin/busco

