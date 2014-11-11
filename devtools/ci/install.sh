sudo apt-get install -qq -y g++ gfortran csh
sudo apt-get install -qq -y g++-multilib gcc-multilib
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
bash Miniconda-latest-Linux-x86_64.sh -b
PIP_ARGS="-U"

export PATH=$HOME/miniconda/bin:$PATH

conda update --yes conda
conda config --add channels http://conda.binstar.org/omnia
conda create --yes -n ${python} python=${python} --file devtools/ci/requirements-conda.txt
source activate $python
$HOME/miniconda/envs/${python}/bin/pip install $PIP_ARGS nose-exclude
