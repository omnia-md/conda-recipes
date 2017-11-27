#!/bin/bash
set -e -x
export MACOSX_DEPLOYMENT_TARGET="10.9"
# Clear existing locks
rm -rf /usr/local/var/homebrew/locks
# Update homebrew (Disabled for test until cache figured out)
#brew update -y --quiet

# Install Miniconda
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels omnia;
conda config --add channels conda-forge;
conda update -yq conda;
conda install -yq conda-env conda-build==2.1.7 jinja2 anaconda-client;
conda config --show;

# Do this step last to make sure conda-build, conda-env, and conda updates come from the same channel first


#export INSTALL_CUDA=`./conda-build-all --dry-run -- openmm`
export INSTALL_OPENMM_PREREQUISITES=true
if [ "$INSTALL_OPENMM_PREREQUISITES" = true ] ; then
    # Install OpenMM dependencies that can't be installed through
    # conda package manager (doxygen + CUDA)
    brew install -y https://raw.githubusercontent.com/Homebrew/homebrew-core/5b680fb58fedfb00cd07a7f69f5a621bb9240f3b/Formula/doxygen.rb
    # Make the nvidia-cache if not there
    mkdir -p $NVIDIA_CACHE
    cd $NVIDIA_CACHE
    # Download missing nvidia installers
    if ! [ -f cuda_mac_installer_tk.tar.gz ]; then
        curl -O -# http://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/Prod/network_installers/mac/x86_64/cuda_mac_installer_tk.tar.gz
    fi
    if ! [ -f cuda_mac_installer_drv.tar.gz ]; then
        curl -O -# http://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/Prod/network_installers/mac/x86_64/cuda_mac_installer_drv.tar.gz
    fi
    sudo tar -zxf cuda_mac_installer_tk.tar.gz -C /;
    sudo tar -zxf cuda_mac_installer_drv.tar.gz -C /;
    # Don't delete the tarballs to cache the package
    # rm -f cuda_mac_installer_tk.tar.gz cuda_mac_installer_drv.tar.gz
    # Now head back to work directory
    cd $TRAVIS_BUILD_DIR

    # Install latex.
    export PATH="/usr/texbin:${PATH}:/usr/bin"
    brew cask install basictex
    mkdir -p /usr/texbin
    # Path based on https://github.com/caskroom/homebrew-cask/blob/master/Casks/basictex.rb location
    # .../texlive/{YEAR}basic/bin/{ARCH}/{Location of actual binaries}
    # Sym link them to the /usr/texbin folder in the path
    export TLREPO=http://ctan.math.utah.edu/ctan/tex-archive/systems/texlive/tlnet
    ln -s /usr/local/texlive/*basic/bin/*/* /usr/texbin/
    sudo tlmgr --repository=$TLREPO update --self
    sleep 5
    sudo tlmgr --persistent-downloads --repository=$TLREPO install \
        titlesec framed threeparttable wrapfig multirow collection-fontsrecommended hyphenat xstring \
        fncychap tabulary capt-of eqparbox environ trimspaces
fi;

# Build packages
./conda-build-all -v $UPLOAD -- *
