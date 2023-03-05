#!/bin/bash

# Run this script every time scripts are newly added or modified

# load entorepo
source /opt/entorepo/.bashrc

rsync -avPh $PWD/scripts/* /opt/entorepo/scripts/

