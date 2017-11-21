#!/bin/bash
set -e
set -x
conda config --add channels omnia
# Move the conda-forge channel to the top
# Cannot just append omnia otherwise default would have higher priority
conda config --add channels conda-forge
conda update -yq conda
conda install -yq conda-build==2.1.17 jinja2 anaconda-client

/io/conda-build-all -vvv --python $PY_BUILD_VERSION $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
