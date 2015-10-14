#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Define global variable
export SDS=/home/openio/build
export LD_LIBRARY_PATH=/home/openio/build/lib
export SDS_TEST_CONFIG_FILE="/home/vagrant/.oio/sds/conf/test.conf"
export PATH=$PATH:${SDS}"/bin"
export TMPDIR=/tmp

# Retrieve oio-sds source
cd ${TMPDIR}
git clone https://github.com/open-io/oio-sds

# Install nose htmloutput (waiting for jenkins integration to implement xunit)
sudo pip install nose-htmloutput

# Test require tox
pkg_install python-tox

# Launch a minimalist instance of oio-sds (no sqlx, no zookeeper, repli x1)
export NOSE_ARGS="--with-html --html-file=${TMPDIR}/nosestests-single.html"
oio-reset.sh -S SINGLE -X sqlx -X zookeeper -R 1 -B 1
cd ${TMPDIR}/oio-sds/python
tox -e func

# Launch functional test
export ADD_META1=3
export ADD_META2=3
export NOSE_ARGS="--with-html --html-file=${TMPDIR}/nosestests-repli3.html"
oio-reset.sh -S SINGLE -X sqlx -R 1 -B 1 -D 1 -S THREECOPIES
cd ${TMPDIR}/oio-sds/python
tox -e func
