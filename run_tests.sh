#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Define global variable
export TMPDIR=/tmp

# Retrieve oio-sds source
cd ${TMPDIR}
git clone https://github.com/open-io/oio-sds

# Install nose htmloutput (waiting for jenkins integration to implement xunit)
sudo pip install nose-htmloutput
export NOSE_ARGS="--with-html-output --html-out-file=${TMPDIR}/nosestests.html"

# Test require tox
pkg_install python-tox

# Launch test
cd ${TMPDIR}/oio-sds/python
tox -e func
