#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Define global variable
export SDS=/home/openio/build
export TMPDIR=/home/openio/tmp

# Install nose htmloutput (waiting for jenkins integration to implement xunit)
pip install nose-htmloutput
export NOSE_ARGS="--with-html-output --html-out-file=${TMPDIR}/nosestests.html"

# Test require tox
pkg_install python-tox

# Launch test
cd ${TMPDIR}/oio-sds/python
tox -e func
