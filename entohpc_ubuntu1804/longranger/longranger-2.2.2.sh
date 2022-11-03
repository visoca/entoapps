#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc


CURRDIR=$PWD

rm -rf longranger-2.2.2.tar.gz longranger-2.2.2 >& /dev/null

wget -O longranger-2.2.2.tar.gz "https://cf.10xgenomics.com/releases/genome/longranger-2.2.2.tar.gz?Expires=1667540285&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvZ2Vub21lL2xvbmdyYW5nZXItMi4yLjIudGFyLmd6IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNjY3NTQwMjg1fX19XX0_&Signature=mqxv~jPs5gLdAp9KQL~Z8B~AIIk2IXHnZsKd74NcsroLrJIBMX8RySajETaAKagVZ3PZIbt1aknE3IY5TVC2B9Xrg~KXl5Pgq1jNWvdwA152-n9nSPGuaRUGnFjX03PuS4yFYiBWCk2JKZRfC~qEuoWWVJVNaM16TAR5Q0QWoP7TFQNEaPpDbLOgPMhXcGkanwjTPozFTGFgSaB7fzOztvtOv1QLYBGBIgayCEQKAovaHKGhg9VKtBvBNMGEvb5Kdb5dlmV2Vke09Pp9ME3BxaYqkc1xGX~Te~UIqjnB0ZMkorLJSX69EGgyGqNWx6LygyA4AHqDxCx6u0kvLX7cPg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

tar -xf longranger-2.2.2.tar.gz
cd longranger-2.2.2

rm -rf /opt/entorepo/apps/longranger/2.2.2
mkdir -p /opt/entorepo/apps/longranger/2.2.2
cp -r * /opt/entorepo/apps/longranger/2.2.2
cd /opt/entorepo/apps/longranger
rm current >& /dev/null
ln -sTf 2.2.2 current

ln -sf /opt/entorepo/apps/longranger/current/longranger /opt/entorepo/bin/
ln -sf /opt/entorepo/apps/longranger/current/longranger-shell /opt/entorepo/bin/

cd $CURRDIR
rm -rf longranger-2.2.2.tar.gz longranger-2.2.2
