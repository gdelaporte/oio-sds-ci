#!/bin/bash

# Define global variable
export SDS=/home/openio/build
export LD_LIBRARY_PATH=/home/openio/build/lib
export PATH=$PATH:${SDS}"/bin"

# Launch a minimalist instance of oio-sds (no sqlx, no zookeeper, repli x1)
oio-reset.sh -S SINGLE -X sqlx -X zookeeper -R 1 -B 1
