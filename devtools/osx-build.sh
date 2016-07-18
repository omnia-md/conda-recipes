#!/bin/bash
set -e -x

# Update homebrew
brew update -y --quiet

# Install Miniconda
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels omnia;
conda install -yq conda-build=1.21.3 jinja2 anaconda-client;

if ! ./conda-build-all --dry-run -- openmm* ; then
    # Install OpenMM dependencies that can't be installed through
    # conda package manager (doxygen + CUDA)
    brew install -y --quiet doxygen
    curl -O -s http://developer.download.nvidia.com/compute/cuda/7.5/Prod/network_installers/mac/x86_64/cuda_mac_installer_tk.tar.gz
    curl -O -s http://developer.download.nvidia.com/compute/cuda/7.5/Prod/network_installers/mac/x86_64/cuda_mac_installer_drv.tar.gz
    sudo tar -zxf cuda_mac_installer_tk.tar.gz -C /;
    sudo tar -zxf cuda_mac_installer_drv.tar.gz -C /;
    rm -f cuda_mac_installer_tk.tar.gz cuda_mac_installer_drv.tar.gz
fi;

# Install latex.
brew tap -y --quiet Caskroom/cask;
sudo brew cask install -y --quiet basictex
export PATH="/usr/texbin:${PATH}:/usr/bin"
sudo tlmgr update --self
sudo tlmgr install titlesec framed threeparttable wrapfig multirow collection-fontsrecommended hyphenat xstring

# Build packages
if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
    ./conda-build-all -vvv $UPLOAD  -- * || true;
else
    ./conda-build-all -vvv $UPLOAD -- *;
fi;
