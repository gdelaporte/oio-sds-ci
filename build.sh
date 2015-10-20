#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Define and create the default building directory
export SDS=/home/openio/build
mkdir -p ${SDS}

# Define and create the default working directory
export TMPDIR=/home/openio/tmp
mkdir -p ${TMPDIR}
cd ${TMPDIR}

# required everywhere
pkg_install git autoconf libtool make gcc

# asn1c
git clone https://github.com/open-io/asn1c.git
cd asn1c
autoreconf -vi && ./configure --enable-{static,shared} --prefix=$SDS
make && make install
cd ..

# librain's dependencies

git clone http://lab.jerasure.org/jerasure/gf-complete.git
cd gf-complete
autoreconf -vi && ./configure --prefix=$SDS
make && make install
cd ..

git clone http://lab.jerasure.org/jerasure/jerasure.git
cd jerasure
autoreconf -vi && ./configure LDFLAGS=-L$SDS/lib/ CPPFLAGS=-I$SDS/include --prefix=$SDS
make && make install
mv $SDS/include/jerasure.h $SDS/include/jerasure/jerasure.h
cd ..

# librain
pkg_install cmake libglib2.0-dev

git clone https://github.com/open-io/librain.git
mkdir build-librain && cd build-librain
cmake \
        -DCMAKE_INSTALL_PREFIX=$SDS \
        -DLD_LIBDIR=lib \
        -DJERASURE_INCDIR=$SDS/include/ \
        -DJERASURE_LIBDIR=$SDS/lib \
        ../librain
make && make install
cd ..

# gridinit and its dependencies
pkg_install libevent-dev

git clone https://github.com/open-io/gridinit.git
mkdir build-gridinit && cd build-gridinit
cmake \
        -DCMAKE_INSTALL_PREFIX=$SDS \
	-DGRIDINIT_SOCK_PATH=/run/gridinit/gridinit.sock\
        -DLD_LIBDIR=lib \
        ../gridinit
make && make install
cd ..

# Dependencies common to the client and the backend
pkg_install \
    flex bison \
    libcurl4-openssl-dev \
    libjson-c-dev

# Dependencies specific to the backend
pkg_install \
    libneon27-dev \
    sqlite3 libsqlite3-0 libsqlite3-dev \
    libzmq3-dev \
    libapr1-dev libaprutil1-dev \
    apache2 apache2-dev \
    libattr1-dev \
    liblzo2-dev \
    libpython-dev \
    libzookeeper-mt-dev

# Required since the SDK_ONLY installation now brings the python part.
pkg_install python-setuptools python-cffi

# Build SDS
git clone https://github.com/open-io/oio-sds.git
mkdir build-oio-sds && cd build-oio-sds
cmake \
        -DCMAKE_INSTALL_PREFIX=$SDS \
        -DLD_LIBDIR=lib \
        -DEXE_PREFIX=oio \
        -DAPACHE2_MODDIR=$SDS/lib/apache2 \
        -DAPACHE2_LIBDIR=/usr/lib/apache2 \
        -DAPACHE2_INCDIR=/usr/include/apache2 \
        -DASN1C_EXE=$SDS/bin/asn1c \
        -DASN1C_INCDIR=$SDS/share/asn1c \
        -DASN1C_LIBDIR=$SDS/lib \
        -DLIBRAIN_INCDIR=$SDS/include \
        -DLIBRAIN_LIBDIR=$SDS/lib \
        -DGRIDINIT_INCDIR=$SDS/include \
        -DGRIDINIT_LIBDIR=$SDS/lib \
        ../oio-sds
make && make install
( cd ../oio-sds && cd python && sudo python ./setup.py develop )
cd ..
