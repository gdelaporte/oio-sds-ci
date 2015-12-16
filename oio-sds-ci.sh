#!/bin/bash

# Usage
while getopts ":r:g:p:b:c:x" opt; do
	case $opt in
		r) REPLICATION_LEVEL="${OPTARG}" ;;
		g) GIT_COMMIT="${OPTARG}" ;;
		p) PULL_ID="${OPTARG}" ;;
		b) BRANCH="${OPTARG}" ;;
		c) COMMIT_ID="${OPTARG}" ;;
		\?) ;;
	esac
done

echo "$0" \
	"-r \"${REPLICATION_LEVEL}\"" \
	"-g \"${GIT_COMMIT}\"" \
	"-p \"${PULL_ID}\"" \
	"-b \"${BRANCH}\"" \
	"-c \"${COMMIT_ID}\"" \

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

sudo apt-get update
pkg_install git

export OIO_HOME="/home/openio"
sudo useradd openio -m -d ${OIO_HOME}
sudo echo "openio ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/openio
sudo su - openio -c "git clone https://github.com/GuillaumeDelaporte/oio-sds-ci ${OIO_HOME}/oio-sds-ci"
sudo ${OIO_HOME}/oio-sds-ci/build.sh -p ${PULL_ID} -b ${BRANCH} -c ${COMMIT_ID}
sudo ${OIO_HOME}/oio-sds-ci/setup.sh
sudo su - openio -c "${OIO_HOME}/oio-sds-ci/run_tests.sh -r ${REPLICATION_LEVEL} -p ${PULL_ID} -b ${BRANCH} -c ${COMMIT_ID}"
