#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

conda remove -n pod5 --all -y
conda create -n pod5 -y
conda activate pod5
conda install pip -y
pip install pod5

# wrapper
cat >pod5.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate pod5

pod5 $*

conda deactivate

EOF
chmod +x pod5.sh

rm -rf /opt/entorepo/apps/pod5/0.2.4-20230831
mkdir -p /opt/entorepo/apps/pod5/0.2.4-20230831
cp -r * /opt/entorepo/apps/pod5/0.2.4-20230831
mv pod5.sh /opt/entorepo/apps/pod5/20230831

cd /opt/entorepo/apps/pod5
rm current >& /dev/null
ln -sTf 0.2.4-20230831 current
ln -sf /opt/entorepo/apps/pod5/current/pod5.sh /opt/entorepo/bin/pod5

cd $CURRDIR
