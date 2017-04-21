* Travis-CI `linux`and `osx` builds [![Travis Build Status](https://travis-ci.org/omnia-md/conda-recipes.svg?branch=master)](https://travis-ci.org/omnia-md/conda-recipes)
* Appveyor-CI `win` builds [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/fyjgl66t943tf2yg/branch/master?svg=true)](https://ci.appveyor.com/project/jchodera/conda-recipes/branch/master)


# omnia-md/conda-recipes

The recipes here create conda packages for scientific and numerical software components associated with the [`omnia`](http://omnia.md) project.
The packages built from these recipes are shared with the community on [anaconda.org](https://anaconda.org/omnia). 
These packages also depend on the `conda-forge` conda channel.

## Installing packages from omnia

To install a package (`mdtraj` for example)
```bash
# Set the channel priority behavior
conda config --set channel_priority false
# Add conda-forge and omnia to your channel list
conda config --add channels conda-forge --add channels omnia
# Install the 'mdtraj' a package
conda install mdtraj
```

The `channel_priority` behavior we configure gives priority to the highest version of the package over all channels.
 
The default behavior (`channel_priority true`) pulls packages from the highest priority chanel, independent of package 
version numbers. An older version package on a higher priority channel will be installed over a newer version 
of the same package on a lower priority channel.

### Important: Channel priority behavior must be disabled for `omnia` to work!

These packages must use the old style of conda channel priority until omnia is entirely on conda-forge!
The instructions below enforce the old channel priority format, please visit 
[the conda documentations on channel priority](https://conda.io/docs/channels.html) 
for more information.

## Migration to conda-forge
The Omnia project has started migrating to [`conda-forge`](https://conda-forge.github.io/). New packages that 
 do not depend on OpenMM should be developed on `conda-forge` and existing packages which do not depend on OpenMM 
 should start migrating if possible.

### Planed Migration Stages

1. (**Current**) Update build image to CentOS 6 from CentOS 5

    The base Docker image for linux builds will be updated to CentOS 6 with its new glibc. The base image is the 
    `conda-forge` anvil, with some [custom addons](https://hub.docker.com/r/jchodera/omnia-linux-anvil/~/dockerfile/) 
    to include things like the AMD SDK, TexLive, and CUDA for GPU builds. The updated version will ensure packages 
    can work on the `conda-forge` platform which is CentOS 6 based.
    
1. For packages that appear in `conda-forge`, remove the corresponding recipes in `omnia`

    We want to minimize the amount of work we have to do as maintainers. To that end, we will stop building things 
    which freely appear on `conda-forge` and maintained by someone other than us!
    For reproducibility purposes, we will keep our previously compiled versions, but they will not longer be updated.  
     
1. Allow recipes that do not depend on OpenMM to migrate from omnia to conda-forge

   * Packages which do not depend on OpenMM and can be run on CPUs only should start migrating over to `conda-forge` 
   in preparation for the total migration. 
   * Packages which can compile with just the `conda-forge` linux-anvil should also start migrating.
   * *We highly encourage devs of individual packages to start migrating now.* 
   * **Once a package is on conda-forge, it should no longer depend packages from omnia!**

1. Determine the appropriate way to build packages which require more than the `conda-forge` linux-anvil can provide

   * The `conda-forge` linux-anvil does not support some things such as some LaTeX packages, AMD SDK, and CUDA files. 
   * We will need to reach out to the conda-forge people to see what the best course of action is
   
1. Migrate OpenMM to `conda-forge`

    * This requires us to identify the best way to add CUDA and AMD APP SDK developer tools to the `conda-forge` 
      linux-anvil docker image. We have some ideas, but no concrete solution yet.

1. Move the remainder of packages to `conda-forge`
   * Also ensure that all former omnia packages can be installed without the `omnia` conda channel  

1. Change this repo into an archive for reproducibility.

### How to migrate to `conda-forge` (for existing packages)

PLACEHOLDER

### Supported versions

Python packages are built against latest two releases of python (3.5 and 3.6) and python 2.7.
Packages which have a binary dependency on [numpy](http://www.numpy.org/) are built against the latest two releases of numpy (1.10 and 1.11).

**WARNING: Python 3.4 support will be phased out now that python 3.6 has been released.**

**WARNING: Numpy 1.09 support will be phased out now that numpy 1.11 has been released.**

### Building the packages

The recipes here are automatically built using [Travis-CI](https://travis-ci.org/) for `linux` and `osx` and [Appveyor-CI](http://www.appveyor.com/) for `win`.

For `linux` builds, we use a modified version of the 
[conda-forge linux-anvil](https://github.com/omnia-md/omnia-linux-anvil/blob/master/Dockerfile), 
to ensure that the packages are fully compatible across multiple linux distributions and versions.
This build image contains the additional tools:
* [TeXLive](https://www.tug.org/texlive/) 2016
* The [CUDA](https://developer.nvidia.com/cuda-toolkit) Toolkit version 8.0
* The [AMD APP SDK](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/) 3.0

There is an additional image which has [clang](http://clang.llvm.org/) 3.8.1 

To build a package yourself, run `conda build <package_name>`, or `./conda-build-all ./*` to build multiple packages across each of the supported python/numpy configurations.

### Contributing a recipe (this has not been updated to reflect the conda-forge changes)

1. Fork this repo
2. Add your `conda` recipe for building your package `packagename` in a subdirectory called `packagename`. Feel free to use other recipes here as examples.
3. Open a pull request to merge your branch into this master repo.
4. It will automatically be tested to make sure it compiles.
5. We will discuss the recipe and give suggestions about how to fix any issues.
6. The recipe will be merged and our automated build framework will build
   and deploy the packages to the `omnia` anaconda channel under the `rc` label.
7. Test the binaries by using `conda install -c omnia/label/rc packagename`
8. When you're sure the binaries are ready for a full release, comment on the
   original pull request and a maintainer will move the package from the `rc`
   label to the main label.

### FAQ

Q: Should I include an `md5` hash in my `source:` section if using a Github compressed archive `url:`?  
A: No. Github compressed archives are frequently regenerated with different compression settings, etc., so `md5` hashes cannot be trusted to be invariant. (#699)
