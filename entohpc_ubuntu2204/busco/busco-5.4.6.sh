#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# conda create -n busco -c conda-forge -c bioconda busco=5.4.6 -y

# wrappers
cat >busco.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate busco

/opt/entorepo/apps/anaconda3/2022.10/envs/busco/bin/busco $*

conda deactivate

EOF
chmod +x busco.sh

cat >busco_generate_plot.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate busco

/opt/entorepo/apps/anaconda3/2022.10/envs/busco/bin/generate_plot.py $*

conda deactivate

EOF
chmod +x busco_generate_plot.sh


rm -rf /opt/entorepo/apps/busco/5.4.6
mkdir -p /opt/entorepo/apps/busco/5.4.6
mv busco.sh /opt/entorepo/apps/busco/5.4.6/
mv busco_generate_plot.sh /opt/entorepo/apps/busco/5.4.6/

cd /opt/entorepo/apps/busco
rm current >& /dev/null
ln -sTf 5.4.6 current
ln -sf /opt/entorepo/apps/busco/current/busco.sh /opt/entorepo/bin/busco
ln -sf /opt/entorepo/apps/busco/current/busco_generate_plot.sh /opt/entorepo/bin/busco_generate_plot

