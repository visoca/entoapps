#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf TransLiG_1.3 TransLiG_1.3.tar.gz >& /dev/null

wget https://sourceforge.net/projects/transcriptomeassembly/files/TransLiG/TransLiG_1.3.tar.gz
tar -xf TransLiG_1.3.tar.gz
cd TransLiG_1.3
export boost_cv_lib_version=1_65_1
./configure --prefix=/opt/entorepo/apps/translig/1.3
make -j12
perl -pi -e 's/^shellpath.*/shellpath\=\$\(\dirname \$\(readlink \-e \$0\)\)/g' TransLiG

rm -rf /opt/entorepo/apps/translig/1.3
mkdir /opt/entorepo/apps/translig/1.3
cp -r * /opt/entorepo/apps/translig/1.3/

cd /opt/entorepo/apps/translig
rm current >& /dev/null
ln -sTf 1.3 current
ln -sf /opt/entorepo/apps/translig/current/TransLiG /opt/entorepo/bin/

cd $CURRDIR

rm -rf TransLiG_1.3 TransLiG_1.3.tar.gz

