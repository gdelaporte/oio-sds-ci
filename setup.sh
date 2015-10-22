#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Install & launch zookeeper
pkg_install zookeeper python-zookeeper
sudo /usr/share/zookeeper/bin/zkServer.sh start

# Install redis
pkg_install redis-server

# Install tox
pkg_install python-tox
