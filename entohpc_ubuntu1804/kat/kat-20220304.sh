#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

conda env remove kat -y
conda create -n kat -c conda-forge -c bioconda kat=2.4.2 -y

# wrapper
cat >kat.sh <<'EOF'
#!/bin/bash

source /opt/entorepo/.bashrc

conda activate kat

/opt/entorepo/apps/anaconda3/2021.05/envs/kat/bin/kat $*

conda deactivate

EOF
chmod +x kat.sh

rm -rf /opt/entorepo/apps/kat/2.4.2-20220304
mkdir -p /opt/entorepo/apps/kat/2.4.2-20220304
mv kat.sh /opt/entorepo/apps/kat/2.4.2-20220304/

cd /opt/entorepo/apps/kat
rm current >& /dev/null
ln -sTf 2.4.2-20220304 current
ln -sf /opt/entorepo/apps/kat/current/kat.sh /opt/entorepo/bin/kat

