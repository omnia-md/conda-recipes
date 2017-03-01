#!/bin/bash
set -e
# Activate Holy Build Box environment.
source /hbb_exe/activate

# Disable PYTHONPATH
unset PYTHONPATH

set -x
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p /anaconda
PATH=/opt/rh/devtoolset-2/root/usr/bin:/anaconda/bin:$PATH
conda config --add channels omnia
conda install -yq conda-build jinja2 anaconda-client
# Install missing LaTeX docs
tlmgr install fncychap tabulary capt-of eqparbox environ trimspaces

/io/conda-build-all -vvv $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
