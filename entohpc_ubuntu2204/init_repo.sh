#!/bin/bash

# Initialise repository

DIR=$(realpath $(dirname $0))

sudo mkdir -p /opt/entorepo/bin
sudo mkdir -p /opt/entorepo/lib/lib
sudo mkdir -p /opt/entorepo/lib/include
sudo chown -R ${USER} /opt/entorepo

${DIR}/bashrc/bashrc.sh
