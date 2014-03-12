conda-recipes
-------------

Recipes for building binary conda packages for (c/)python tools I use and develop. Built binaries from these recipes are hosted on [binstar.org](https://binstar.org/omnia).

To install packages run,

```
# Add my channel
$ conda config --add channels http://conda.binstar.org/omnia

# Install one of our packages, like MDTraj
conda install mdtraj

# Or OpenMM
conda install openmm
```

