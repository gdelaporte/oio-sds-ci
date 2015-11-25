#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

sudo apt-get update
pkg_install git

TESTS_ARGS=$1

export OIO_HOME="/home/openio"
sudo useradd openio -m -d ${OIO_HOME}
sudo su - openio -c "git clone https://github.com/GuillaumeDelaporte/oio-sds-ci ${OIO_HOME}/oio-sds-ci"
sudo ${OIO_HOME}/oio-sds-ci/build.sh
sudo ${OIO_HOME}/oio-sds-ci/setup.sh
sudo su - openio -c "${OIO_HOME}/oio-sds-ci/run_tests.sh ${TESTS_ARGS}"
