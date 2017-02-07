* Travis-CI `linux`and `osx` builds [![Travis Build Status](https://travis-ci.org/omnia-md/conda-recipes.svg?branch=master)](https://travis-ci.org/omnia-md/conda-recipes)
* Appveyor-CI `win` builds [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/fyjgl66t943tf2yg/branch/master?svg=true)](https://ci.appveyor.com/project/jchodera/conda-recipes/branch/master)


omnia-md/conda-recipes
----------------------

The recipes here create conda packages for scientific and numerical software components associated with the [`omnia`](http://omnia.md) project.
The packages built from these recipes are shared with the community on [anaconda.org](https://anaconda.org/omnia).

### Installing packages from omnia

To install a package
```bash
# Add the omnia channel
$ conda config --add channels omnia
# Install the 'mdtraj' a package
$ conda install mdtraj
```

### Supported versions

Python packages are built against latest two releases of python (3.5 and 3.6) and python 2.7.
Packages which have a binary dependency on [numpy](http://www.numpy.org/) are built against the latest two releases of numpy (1.10 and 1.11).

**WARNING: Python 3.4 support will be phased out now that python 3.6 has been released.**

**WARNING: Numpy 1.09 support will be phased out now that numpy 1.11 has been released.**

### Building the packages

The recipes here are automatically built using [Travis-CI](https://travis-ci.org/) for `linux` and `osx` and [Appveyor-CI](http://www.appveyor.com/) for `win`.

For `linux` builds, we use a modified version of the [Holy Build Box](http://phusion.github.io/holy-build-box/), available [here](https://github.com/omnia-md/omnia-build-box), to ensure that the packages are fully compatible across multiple linux distributions and versions.
This build image contains the additional tools:
* [clang](http://clang.llvm.org/) 3.8.1
* [TeXLive](https://www.tug.org/texlive/) 2015
* The [CUDA](https://developer.nvidia.com/cuda-toolkit) Toolkit version 8.0
* The [AMD APP SDK](http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/) 3.0

To build a package yourself, run `conda build <package_name>`, or `./conda-build-all ./*` to build multiple packages across each of the supported python/numpy configurations.

### Contributing a recipe

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
