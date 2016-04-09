#!/bin/bash
set -e
# Activate Holy Build Box environment.
source /hbb_exe/activate

# Disable PYTHONPATH
unset PYTHONPATH

set -x
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p /anaconda
PATH=/opt/rh/devtoolset-2/root/usr/bin:/opt/rh/autotools-latest/root/usr/bin:/anaconda/bin:$PATH
conda config --add channels omnia
conda install -yq conda-build jinja2 anaconda-client
# temporary hack until we setup maccallumlab package
# for eigen3
conda config --add channel Juanlu001
conda install eigen3

if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
    /io/conda-build-all $UPLOAD --check-against omnia omnia/label/pre -- /io/* || true
else
    /io/conda-build-all $UPLOAD --check-against omnia omnia/label/pre -- /io/*
fi

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
