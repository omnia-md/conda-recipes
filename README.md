* Travis dependency resolution test: [![Travis dependency resolution test](https://travis-ci.org/omnia-md/conda-recipes.svg?branch=master)](https://travis-ci.org/omnia-md/conda-recipes)
* Jenkins `osx` build: [![Jenkins `osx` build](https://jenkins.choderalab.org/job/conda-omnia-release-osx-2/badge/icon)](https://jenkins.choderalab.org/job/conda-omnia-release-osx-2/)
* Jenkins `linux` build: [![Jenkins `linux` build](https://jenkins.choderalab.org/job/conda-omnia-release-linux-vagrant/badge/icon)](https://jenkins.choderalab.org/job/conda-omnia-release-linux-vagrant/)

conda-recipes
-------------

Recipes for building binary conda packages for (c/)python components of the omnia project.
Built binaries from these recipes are hosted on [binstar.org](https://binstar.org/omnia).

To install packages run,

```
# Add my channel
$ conda config --add channels http://conda.binstar.org/omnia

# Install one of our packages, like MDTraj
conda install mdtraj

# Or OpenMM
conda install openmm
```

To build a single Omnia conda package:

```
conda build packagename
```

To build all Omnia conda packages, you can use the included script:

```
python build-all.py
```
Or the other script:

```
./conda-build-all ./*
```


To upload to the Omnia binstar org, use

```
binstar upload -u omnia package.bz2
```

Command taken from this forum post: [From Binstar Forums](https://groups.google.com/a/continuum.io/forum/#!topic/conda/uYtVRGW--iU)

To upload multiple packages to the test channel (for beta testing / pre-release)

```
binstar login  # workaround bug in binstar login.
binstar upload /home/vagrant/miniconda/conda-bld/linux-64/*.bz2  -u omnia --channel test
```
