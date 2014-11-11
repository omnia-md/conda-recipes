[![Build Status](https://travis-ci.org/jchodera/conda-recipes.svg)](https://travis-ci.org/jchodera/conda-recipes)

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
sh build-all.sh
```


To upload to the Omnia binstar org, use

```
binstar upload -u omnia package.bz2
```

Command taken from this forum post: [From Binstar Forums](https://groups.google.com/a/continuum.io/forum/#!topic/conda/uYtVRGW--iU)

