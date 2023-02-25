#!/bin/bash

# entorepo bashrc to be add to users .bash_profile

cat > /opt/entorepo/.bashrc <<'EOF'
echo
echo "  ********************************************"
echo "  ** Your account is set up to use entorepo **"
echo "  ********************************************"
echo 


# path to executables and libraries
export PATH=/opt/entorepo/bin:$PATH
export PATH=/opt/entorepo/lib/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/entorepo/lib/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/entorepo/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/entorepo/lib/lib/pkgconfig

source /opt/entorepo/apps/anaconda3/2022.10/etc/profile.d/conda.sh

EOF
