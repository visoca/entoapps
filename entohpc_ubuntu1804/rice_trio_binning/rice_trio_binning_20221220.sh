#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf trio_binning >& /dev/null

conda create -n trio_binning python -y
conda activate trio_binning

git clone https://github.com/esrice/trio_binning.git
cd trio_binning
pip install .

cd $CURRDIR
rm -rf trio_binning
