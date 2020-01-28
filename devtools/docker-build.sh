#!/bin/bash

set -xeuo pipefail

export PYTHONUNBUFFERED=1
export CONFIG_FILE="/conda_configs/${CONFIG}.yaml"
export CONDA_BLD_PATH="${HOME}/build_artifacts"
mkdir -p ${CONDA_BLD_PATH}

cat >~/.condarc <<CONDARC

conda-build:
 root-dir: ${CONDA_BLD_PATH}

CONDARC

# Channels are added in FIFO order here
conda config --add channels omnia
conda config --add channels conda-forge

conda install --yes conda conda-build anaconda-client

conda config --set show_channel_urls true
conda config --set auto_update_conda false
conda config --set add_pip_as_python_dependency false

conda info
conda config --show-sources
conda list --show-channel-urls


/io/conda-build-all $CBA_FLAGS -m ${CONFIG_FILE} -- /io/recipes/*/

