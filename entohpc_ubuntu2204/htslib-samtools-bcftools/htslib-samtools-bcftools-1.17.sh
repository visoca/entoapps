#!/bin/bash

# required libraries
# sudo apt install liblzma-dev libncurses-dev libbz2-dev
# load entorepo
source /opt/entorepo/.bashrc

CURRDIR=$PWD

# htslib
# --------------------------------------------------------------
rm -rf htslib-1.17 htslib-1.17.tar.bz2 >& /dev/null

wget https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2
tar -xf htslib-1.17.tar.bz2
cd htslib-1.17
autoreconf -i
LDFLAGS="-L/opt/entorepo/lib/lib" \
CPPFLAGS="-I/opt/entorepo/lib/include/" \
./configure \
--prefix=/opt/entorepo/lib/htslib/1.17
make -j12
rm -rf  /opt/entorepo/lib/htslib/1.17 >& /dev/null
make install

cd /opt/entorepo/lib/htslib
ln -sfT 1.17 current
ln -sf /opt/entorepo/lib/htslib/current/bin/* /opt/entorepo/bin/ 
ln -sf /opt/entorepo/lib/htslib/current/lib/* /opt/entorepo/lib/lib/ 
ln -sf /opt/entorepo/lib/lib/htslib/current/lib/pkgconfig/* /opt/entorepo/lib/lib/pkgconfig/
ln -sf /opt/entorepo/lib/htslib/current/include/* /opt/entorepo/lib/include/

cd $CURRDIR
rm -rf htslib-1.17 htslib-1.17.tar.bz2
# --------------------------------------------------------------

# samtools
# --------------------------------------------------------------
rm -rf samtools-1.17 samtools-1.17.tar.bz2 >& /dev/null

wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2
tar -xf samtools-1.17.tar.bz2
cd samtools-1.17
autoreconf -i
LDFLAGS="-L/opt/entorepo/lib/lib" \
CPPFLAGS="-I/opt/entorepo/lib/include/" \
./configure \
--prefix=/opt/entorepo/apps/samtools/1.17 \
--with-htslib=/opt/entorepo/lib/htslib/1.17 
make
rm -rf /opt/entorepo/apps/samtools/1.17 >& /dev/null
make install

cd /opt/entorepo/apps/samtools
ln -sfT 1.17 current
ln -sf /opt/entorepo/apps/samtools/current/bin/* /opt/entorepo/bin/ 

cd $CURRDIR
rm -rf samtools-1.17 samtools-1.17.tar.bz2
# --------------------------------------------------------------

# bcftools
# --------------------------------------------------------------
rm -rf bcftools-1.17 bcftools-1.17.tar.bz2 >& /dev/null

wget https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2
tar -xf bcftools-1.17.tar.bz2
cd bcftools-1.17
autoreconf -i
LDFLAGS="-L/opt/entorepo/lib/lib" \
CPPFLAGS="-I/opt/entorepo/lib/include/" \
./configure \
--prefix=/opt/entorepo/apps/bcftools/1.17 \
--with-htslib=/opt/entorepo/lib/htslib/1.17 
make
rm -rf /opt/entorepo/apps/bcftools/1.17 >& /dev/null
make install


cd /opt/entorepo/apps/bcftools
ln -sfT 1.17 current

# correct shebang of vcfutils.pl and plot-roh.py
perl -pi -e 's/\#\!\/usr\/bin\/perl \-w/\#\!\/usr\/bin\/env perl/g' /opt/entorepo/apps/bcftools/1.17/bin/vcfutils.pl
perl -pi -e 's/\#\!\/usr\/bin\/python/\#\!\/usr\/bin\/env python/g' /opt/entorepo/apps/bcftools/1.17/bin/plot-roh.py

ln -sf /opt/entorepo/apps/bcftools/current/bin/* /opt/entorepo/bin/ 
ln -sf /opt/entorepo/apps/bcftools/current/libexec/* /opt/entorepo/lib/lib/

cd $CURRDIR
rm -rf bcftools-1.17 bcftools-1.17.tar.bz2
# --------------------------------------------------------------


