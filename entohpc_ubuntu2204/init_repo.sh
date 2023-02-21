#!/bin/bash

# Initialise repository

DIR=$(realpath $(dirname $0))

sudo mkdir -p /opt/entorepo
sudo chown ${USER} /opt/entorepo

${DIR}/bashrc/bashrc.sh
