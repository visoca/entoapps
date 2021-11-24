#!/bin/bash

# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

rm -rf orp-transrate orp-transrate.tar.gz entorepo-transrate entorepo-transrate.tar.gz >& /dev/null

wget https://github.com/macmanes-lab/Oyster_River_Protocol/raw/master/software/orp-transrate.tar.gz
tar -xf orp-transrate.tar.gz
mv orp-transrate entorepo-transrate
cd entorepo-transrate/bin

# Change snap and salmon versions
rm snap-aligner salmon
ln -s /opt/entorepo/apps/snap/2.0.0/snap-aligner .
ln -s /opt/entorepo/apps/salmon/1.6.0/bin/salmon .

cd ..
cat > lib/app/deps/deps.yaml <<EOF
snap:
  binaries:
    - snap-aligner
  version:
    number: '2.0.0'
    command: 'snap-aligner'
  url:
    64bit:
      linux: 
bam-read:
  binaries:
   - bam-read
  version:
    number: '1.0.0'
    command: 'bam-read'
  url:
    64bit:
      linux: https://github.com/Blahah/transrate-tools/releases/download/v1.0.0/bam-read_v1.0.0_linux.tar.gz
  unpack: true
salmon:
  binaries:
    - salmon
  version:
    number: '1.6.0'
    command: 'salmon -v'
  url:
    64bit:
      linux: 

EOF

# modify command line for salmon (remove --useErrorModel option, which is deprecated)
perl -pi -e 's/.*--useErrorModel.*\n//g' lib/app/lib/transrate/salmon.rb

rm -rf /opt/entorepo/apps/transrate/1.0.3
mkdir -p /opt/entorepo/apps/transrate/1.0.3
cp -r * /opt/entorepo/apps/transrate/1.0.3/

# save version
cd ..
tar -zcvf entorepo-transrate.tar.gz entorepo-transrate/

cd /opt/entorepo/apps/transrate
rm current >& /dev/null
ln -sTf 1.0.3 current
ln -sf /opt/entorepo/apps/transrate/current/transrate /opt/entorepo/bin/

cd $CURRDIR

rm -rf entorepo-transrate orp-transrate.tar.gz

