#!/bin/bash
set -e -x

# Update homebrew
brew uninstall -y brew-cask || brew untap -y caskroom/cask || 1
brew update -y --quiet
brew tap -y caskroom/cask

# Install Miniconda
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels omnia;
conda config --show;
conda install -yq conda-build jinja2 anaconda-client;

#export INSTALL_CUDA=`./conda-build-all --dry-run -- openmm`
export INSTALL_OPENMM_PREREQUISITES=true
if [ "$INSTALL_OPENMM_PREREQUISITES" = true ] ; then
    # Install OpenMM dependencies that can't be installed through
    # conda package manager (doxygen + CUDA)
    brew install -y https://raw.githubusercontent.com/Homebrew/homebrew-core/5b680fb58fedfb00cd07a7f69f5a621bb9240f3b/Formula/doxygen.rb
    curl -O -s http://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/Prod/network_installers/mac/x86_64/cuda_mac_installer_tk.tar.gz
    curl -O -s http://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/Prod/network_installers/mac/x86_64/cuda_mac_installer_drv.tar.gz
    sudo tar -zxf cuda_mac_installer_tk.tar.gz -C /;
    sudo tar -zxf cuda_mac_installer_drv.tar.gz -C /;
    rm -f cuda_mac_installer_tk.tar.gz cuda_mac_installer_drv.tar.gz

    # Install latex.
    brew cask install -y basictex
    export PATH="/usr/texbin:${PATH}:/usr/bin"
    sudo tlmgr update --self
    sleep 5
    sudo tlmgr --persistent-downloads install titlesec framed threeparttable wrapfig multirow collection-fontsrecommended hyphenat xstring
fi;

# Build packages
./conda-build-all -vvv $UPLOAD -- *
