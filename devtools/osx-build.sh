#!/bin/bash
set -e -x
export MACOSX_DEPLOYMENT_TARGET="10.10"
# Clear existing locks
#rm -rf /usr/local/var/homebrew/locks
# Update homebrew cant disable this yet, -y and --quiet do nothing
#brew update

# Install Miniconda
curl -s -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels openeye
conda config --add channels conda-forge;
conda config --add channels omnia;
conda install -yq conda\<=4.3.34 python=3.6;
#####################################################################
# WORKAROUND FOR BUG WITH ruamel_yaml
# "conda config --add channels omnia/label/dev" will fail if ruamel_yaml > 0.15.54
# This workaround is in place to avoid this failure until this is patched
# See: https://github.com/conda/conda/issues/7672
conda install --yes ruamel_yaml==0.15.53 conda\<=4.3.34;
#####################################################################
#conda config --add channels omnia-dev
conda install -yq conda-env conda-build==2.1.7 jinja2 anaconda-client;
conda config --show;
conda clean -tipsy;

# Do this step last to make sure conda-build, conda-env, and conda updates come from the same channel first


#export INSTALL_CUDA=`./conda-build-all --dry-run -- openmm`
export INSTALL_OPENMM_PREREQUISITES=false
if [ "$INSTALL_OPENMM_PREREQUISITES" = true ] ; then
    # Install OpenMM dependencies that can't be installed through
    # conda package manager (doxygen + CUDA)
    #brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/5b680fb58fedfb00cd07a7f69f5a621bb9240f3b/Formula/doxygen.rb
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
    # TODO: Don't delete the tarballs to cache the package, if we can spare the space
    rm -f cuda_mac_installer_tk.tar.gz cuda_mac_installer_drv.tar.gz
    # Now head back to work directory
    cd $TRAVIS_BUILD_DIR

    # Install latex.
    export PATH="/usr/texbin:${PATH}:/usr/bin"
    #brew cask install --no-quarantine basictex
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
        fncychap tabulary capt-of eqparbox environ trimspaces \
        cmap fancybox titlesec framed fancyvrb threeparttable \
        mdwtools wrapfig parskip upquote float multirow hyphenat caption \
        xstring fncychap tabulary capt-of eqparbox environ trimspaces \
        varwidth needspace
    # Clean up brew
    #brew cleanup -s
fi;

# Build packages
export CUDA_SHORT_VERSION

# Make sure we have the appropriate channel added
conda config --add channels omnia/label/cuda${CUDA_SHORT_VERSION};
conda config --add channels omnia/label/rc;
conda config --add channels omnia/label/rccuda${CUDA_SHORT_VERSION};
#conda config --add channels omnia/label/beta;
conda config --add channels omnia/label/betacuda${CUDA_SHORT_VERSION};
#conda config --add channels omnia/label/dev;
#conda config --add channels omnia/label/devcuda${CUDA_SHORT_VERSION};

#for PY_BUILD_VERSION in "27" "35" "36" "37"; do
#for PY_BUILD_VERSION in "37" "36" "35" "27"; do
#    ./conda-build-all -vvv --python $PY_BUILD_VERSION --check-against omnia --check-against omnia/label/cuda${CUDA_SHORT_VERSION} --check-against omnia/label/beta --check-against omnia/label/betacuda${CUDA_SHORT_VERSION} --numpy "1.15" $UPLOAD -- *
#done
./conda-build-all -vvv --python "37,36,27" --numpy "1.16,1.18" $UPLOAD -- *
