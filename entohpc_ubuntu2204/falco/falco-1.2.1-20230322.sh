#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf falco >& /dev/null

git clone https://github.com/smithlabcode/falco.git
cd falco
make -j 12 all
make install

rm -rf /opt/entorepo/apps/falco/1.2.1-20230322 >& /dev/null
mkdir -p /opt/entorepo/apps/falco/1.2.1-20230322
cp -r * /opt/entorepo/apps/falco/1.2.1-20230322/

cd /opt/entorepo/apps/falco
rm current >& /dev/null
ln -sTf 1.2.1-20230322 current

ln -sf /opt/entorepo/apps/falco/current/bin/* /opt/entorepo/bin/

cd $CURRDIR
rm -rf falco
