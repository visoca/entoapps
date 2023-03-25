#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

conda create -n busco -c conda-forge -c bioconda busco=5.4.6 -y

# wrapper
cat >busco.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate busco

/opt/entorepo/apps/anaconda3/2022.10/envs/busco/bin/busco $*

conda deactivate

EOF
chmod +x busco.sh

rm -rf /opt/entorepo/apps/busco/5.4.6
mkdir -p /opt/entorepo/apps/busco/5.4.6
mv busco.sh /opt/entorepo/apps/busco/5.4.6/

cd /opt/entorepo/apps/busco
rm current >& /dev/null
ln -sTf 5.4.6 current
ln -sf /opt/entorepo/apps/busco/current/busco.sh /opt/entorepo/bin/busco

