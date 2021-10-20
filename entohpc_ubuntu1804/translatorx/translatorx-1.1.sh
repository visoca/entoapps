#!/bin/bash

# Load entorepo bashrc
source /opt/entorepo/.bashrc

# Note: requires several external programmes

CURRDIR=$PWD
rm -rf translatorx_vLocal.pl >& /dev/null

wget http://161.111.161.41/cgi-bin/translatorx_vLocal.pl
chmod +x translatorx_vLocal.pl

rm -rf /opt/entorepo/apps/translatorx/1.1 >& /dev/null
mkdir -p /opt/entorepo/apps/translatorx/1.1
cp translatorx_vLocal.pl /opt/entorepo/apps/translatorx/1.1

cd /opt/entorepo/apps/translatorx
ln -sTf 1.1 current

ln -sf /opt/entorepo/apps/translatorx/current/translatorx_vLocal.pl /opt/entorepo/bin

cd $CURRDIR
rm -rf translatorx_vLocal.pl

