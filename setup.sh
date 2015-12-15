#!/bin/bash

# Define the packager installion function
# For Ubuntu only in this first version : apt-get
function pkg_install () { sudo apt-get -y install $@ ; }

# Install & launch zookeeper
pkg_install zookeeper python-zookeeper
sudo /usr/share/zookeeper/bin/zkServer.sh start

# Add new repo with latest version of redis
pkg_install python-software-properties
sudo add-apt-repository -y ppa:rwky/redis
sudo apt-get update
# Install redis
pkg_install redis-server

# Install tox
pkg_install python-tox
