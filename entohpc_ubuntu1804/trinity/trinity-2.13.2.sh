#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf trinityrnaseq-v2.13.2 trinityrnaseq-v2.13.2.FULL.tar.gz >& /dev/null

wget https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v2.13.2/trinityrnaseq-v2.13.2.FULL.tar.gz
tar -xf trinityrnaseq-v2.13.2.FULL.tar.gz
cd trinityrnaseq-v2.13.2/
make
make plugins
perl -pi -e 's/destination_package_dir =.*/destination_package_dir = \"\/opt\/entorepo\/apps\/trinity\/2.13.2\"/g' util/support_scripts/trinity_installer.py

rm -rf /opt/entorepo/apps/trinity/2.13.2 >& /dev/null

mkdir -p /opt/entorepo/apps/trinity/2.13.2
make install

cd /opt/entorepo/apps/trinity
rm current >& /dev/null
ln -sTf 2.13.2 current

cd /opt/entorepo/apps/trinity/current

# wrapper
cat > trinity.sh <<'EOF'
#!/bin/bash

# Wrapper to run Trinity

export TRINITY_HOME="/opt/entorepo/apps/trinity/current"

/opt/entorepo/apps/trinity/current/Trinity $*

EOF

ln -sf /opt/entorepo/apps/trinity/current/trinity.sh /opt/entorepo/bin/trinity

cd $CURRDIR
rm -rf trinityrnaseq-v2.13.2 trinityrnaseq-v2.13.2.FULL.tar.gz 
