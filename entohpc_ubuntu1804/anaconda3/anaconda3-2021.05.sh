#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf Anaconda3-2021.05-Linux-x86_64.sh >& /dev/null

wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh

# install anaconda
rm -rf /opt/entorepo/apps/anaconda3/2021.05 >& /dev/null
sh Anaconda3-2021.05-Linux-x86_64.sh -b -p /opt/entorepo/apps/anaconda3/2021.05

# update conda
/opt/entorepo/apps/anaconda3/2021.05/bin/conda update conda -y

# create basic environments
/opt/entorepo/apps/anaconda3/2021.05/bin/conda create --name py27 python=2.7 anaconda -y
/opt/entorepo/apps/anaconda3/2021.05/bin/conda create --name py36 python=3.6 anaconda -y

# install modules
/opt/entorepo/apps/anaconda3/2021.05/bin/conda install pip numpy scipy cython mkl -y

# create links
ln -sf /opt/entorepo/apps/anaconda3/2021.05/bin/conda /opt/entorepo/bin/
ln -sf /opt/entorepo/apps/anaconda3/2021.05/bin/activate /opt/entorepo/bin/
ln -sf /opt/entorepo/apps/anaconda3/2021.05/bin/deactivate /opt/entorepo/bin/

cd $CURRDIR
rm -rf Anaconda3-2021.05-Linux-x86_64.sh
