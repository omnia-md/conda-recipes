wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_6.5-14_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1404_6.5-14_amd64.deb
sudo apt-get update
sudo apt-get install cuda

sudo apt-get install -qq -y g++ gfortran csh
sudo apt-get install -qq -y g++-multilib gcc-multilib
sudo apt-get install -qq -y doxygen

wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
bash Miniconda-latest-Linux-x86_64.sh -b
PIP_ARGS="-U"

export PATH=$HOME/miniconda/bin:$PATH

conda update --yes conda
conda config --add channels http://conda.binstar.org/omnia
conda install --yes conda-build jinja2
conda install --yes --file devtools/ci/requirements-conda.txt
pip install $PIP_ARGS nose-exclude
