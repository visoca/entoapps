#!/bin/bash

# Set up current account to use entorepo

cat >> $HOME/.bashrc << EOF

# Set up entorepo
source /opt/entorepo/.bashrc
 
EOF
