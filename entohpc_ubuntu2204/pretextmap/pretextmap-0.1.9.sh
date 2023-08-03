#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

# conda config --add channels defaults
# conda config --add channels bioconda

conda env remove -n pretextmap -y
conda create -n pretextmap -y
conda activate pretextmap
conda install pretextmap -y


# wrapper
cat >pretextmap.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate pretextmap

PretextMap $*

conda deactivate

EOF
chmod +x pretextmap.sh

rm -rf /opt/entorepo/apps/pretextmap/0.1.9 >& /dev/null
mkdir -p /opt/entorepo/apps/pretextmap/0.1.9
mv pretextmap.sh /opt/entorepo/apps/pretextmap/0.1.9/

mkdir -p /opt/entorepo/apps/pretextmap >& /dev/null
cd /opt/entorepo/apps/pretextmap
rm current >& /dev/null
ln -sTf 0.1.9 current

ln -sf /opt/entorepo/apps/pretextmap/current/pretextmap.sh /opt/entorepo/bin/pretextmap

