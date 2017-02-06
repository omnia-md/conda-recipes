#!/bin/bash
set -e
set -x

conda config --remove channels conda-forge
conda config --add channels omnia
conda install -yq conda-build jinja2 anaconda-client

/io/conda-build-all -vvv $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
