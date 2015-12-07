#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Define global variable
export SDS=/home/openio/build
export LD_LIBRARY_PATH=/home/openio/build/lib
export SDS_TEST_CONFIG_FILE="/home/openio/.oio/sds/conf/test.conf"
export PATH=$PATH:${SDS}"/bin"
export TMPDIR=/tmp

# Retrieve oio-sds source
cd ${TMPDIR}
git clone https://github.com/open-io/oio-sds

# Install nose htmloutput (waiting for jenkins integration to implement xunit)
sudo pip install nose-htmloutput

# Launch a minimalist instance of oio-sds (no sqlx, no zookeeper, repli x1)
function run_single_instance () {
	export NOSE_ARGS="--with-xunit --xunit-file=${TMPDIR}/nosestests-single.xml --with-html --html-file=${TMPDIR}/nosestests-single.html"
	oio-reset.sh -S SINGLE -X sqlx -X zookeeper -R 1 -B 1
	cd ${TMPDIR}/oio-sds/python
	tox -e func
}

# Launch functional test
function run_repli3_instance () {
	export ADD_META1=3
	export ADD_META2=3
	export NOSE_ARGS="--with-xunit --xunit-file=${TMPDIR}/nosestests-replix3.xml --with-html --html-file=${TMPDIR}/nosestests-replix3.html"
	oio-reset.sh -S SINGLE -X sqlx -R 1 -B 3 -D 3 -S THREECOPIES
	cd ${TMPDIR}/oio-sds/python
	tox -e func
}

case "$1" in
        single)
            run_single_instance
            ;;

        replix3)
            run_repli3_instance
            ;;

        *)
 	    run_single_instance
	    run_repli3_instance
esac
