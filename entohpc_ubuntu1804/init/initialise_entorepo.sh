 #!/bin/bash

#  initial steps to set up entorepo

# create entorepo admin group and add admins
# sudo groupadd entorepoadm
# sudo usermod -a -G entorepoadm soriaca

sudo mkdir /opt/entorepo/bin
sudo chown soriaca:entorepoadm -R /opt/entorepo
chmod 775 -R /opt/entorepo

