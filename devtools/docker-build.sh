#!/bin/bash
set -e
set -x

conda config --remove channels conda-forge
conda config --add channels omnia
conda install -yq conda-build jinja2 anaconda-client

if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
    /io/conda-build-all -vvv $UPLOAD -- /io/* || true
else
    /io/conda-build-all -vvv $UPLOAD -- /io/*
fi

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
