#!/bin/bash
set -e
set -x
conda config --add channels omnia
conda config --add channels omnia/label/dev
# Move the conda-forge channel to the top
# Cannot just append omnia otherwise default would have higher priority
conda config --add channels conda-forge
conda install -yq conda\<=4.3.34
conda install -yq conda-build==2.1.17 jinja2 anaconda-client

/io/conda-build-all -vvv $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
