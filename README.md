* Travis-CI `linux`and `osx` builds [![Travis Build Status](https://travis-ci.org/omnia-md/conda-recipes.svg?branch=master)](https://travis-ci.org/omnia-md/conda-recipes)
* Appveyor-CI `win` builds [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/fyjgl66t943tf2yg/branch/master?svg=true)](https://ci.appveyor.com/project/jchodera/conda-recipes/branch/master)


# omnia-md/conda-recipes

The recipes here create conda packages for scientific and numerical software components associated with the [`omnia`](http://omnia.md) project.
The packages built from these recipes are shared with the community on [anaconda.org](https://anaconda.org/omnia).
These packages also depend on the `conda-forge` conda channel.

## Installing packages from omnia

To install a package (`mdtraj` for example)
```bash
# Add conda-forge and omnia to your channel list, one time action
conda config --add channels omnia --add channels conda-forge
# Install the 'mdtraj' a package
conda install mdtraj
```

To install a package in one line:
```bash
# channels searched in order they are added here
conda install -c conda-forge -c omnia mdtraj
```

When setting up the configuration through `conda config`, the channels are added to the top of the search priority
sequentially. So `conda config --add channels omnia --add channels conda-forge` first adds `omnia` to the top of the
list, then adds `conda-forge` on top of that, giving `conda-forge` the highest priority.

When temporarily searching through channels with `conda install`, the channels are prioritized in the order they
are provided. So `conda install -c conda-forge -c omnia` prioritizes `conda-forge` first, then `omnia`.

## Installing development packages

Some Omnia projects, such as `openmm`, have nightly development builds packaged and pushed to the Anaconda cloud.
These can be found at https://anaconda.org/omnia-dev

If you want to install the development version of a particular package, use the `omnia-dev` channel.
For example, to install the development snapshot of `openmm`, use:
```bash
conda install -c omnia-dev openmm
```
To ensure that development versions are always installed if available, add them to your conda channels (but only if you are sure you _always_ want the bleeding-edge development snapshots!):
```bash
conda config --add channels omnia-dev
```

## Migration to conda-forge
The Omnia project has started migrating to [`conda-forge`](https://conda-forge.github.io/). New packages that
 do not depend on OpenMM should be developed on `conda-forge` and existing packages which do not depend on OpenMM
 should start migrating if possible.

### Planed Migration Stages

1. Update build image to CentOS 6 from CentOS 5

    The base Docker image for linux builds will be updated to CentOS 6 with its new glibc. The base image is the
    `conda-forge` anvil, with some [custom addons](https://hub.docker.com/r/jchodera/omnia-linux-anvil/~/dockerfile/)
    to include things like the AMD SDK, TexLive, and CUDA for GPU builds. The updated version will ensure packages
    can work on the `conda-forge` platform which is CentOS 6 based.

1. (**Current**) For packages that appear in `conda-forge`, remove the corresponding recipes in `omnia`

    We want to minimize the amount of work we have to do as maintainers. To that end, we will stop building things
    which freely appear on `conda-forge` and maintained by someone other than us!
    For reproducibility purposes, we will keep our previously compiled versions, but they will not longer be updated.
    * Developers: if you want users to still exclusivley use the `omnia` conda channel, please see the **Copying from conda-forge** section below

1. Allow recipes that do not depend on OpenMM to migrate from omnia to conda-forge

   * Packages which do not depend on OpenMM and can be run on CPUs only should start migrating over to `conda-forge`
   in preparation for the total migration.
   * Packages which can compile with just the `conda-forge` linux-anvil should also start migrating.
   * *We highly encourage devs of individual packages to start migrating now.*
   * **Once a package is on conda-forge, it should no longer depend packages from omnia!**

1. Determine the appropriate way to build packages which require more than the `conda-forge` linux-anvil can provide

   * The `conda-forge` linux-anvil does not support some things such as TeXLive with requisite LaTeX packages (required by sphinx and/or OpenMM's sphinx configuration) and the CUDA Toolkit.
   * We will need to reach out to the conda-forge people to see what the best course of action is

1. Migrate OpenMM to `conda-forge`

    * This requires us to identify the best way to add the CUDA Toolkit and TeXLive to the `conda-forge`
      `linux-anvil` docker image.
      We have some ideas, but no concrete solution yet.
      In particular, the [`anaconda` channel provides `cudatoolkit`](https://anaconda.org/anaconda/cudatoolkit/files), but not all versions are available yet.
      [`conda-forge` is also experimenting with](https://anaconda.org/conda-forge/cudatoolkit-dev/files) builds.
      `conda-forge` also has a [`texlive-core` package](https://anaconda.org/conda-forge/texlive-core), but `tlmgr` package installs are not supported; it may be possible to prepare [selections of TeXLive packages](https://anaconda.org/pkgw/texlive-selected).

1. Move the remainder of packages to `conda-forge`
   * Also ensure that all former omnia packages can be installed without the `omnia` conda channel  

1. Change this repo into an archive for reproducibility.

### How to migrate to `conda-forge` (for existing packages)

PLACEHOLDER

### Copying from Conda Forge

It can be a bit confusing to rely on two conda channels where the order they are specified in changes which version of
packages are installed. During the migration to `conda-forge`, developers can copy their binary tarballs from
`conda-forge` to the `omnia` channel using the Anaconda Cloud API, allowing users to rely only on the `omnia` channel.
There are a couple conditions for this though:

* Packages still built in `omnia` will search for dependencies in `conda-forge` then `omnia`, in that order
* Your package should **not** depend on packages which only exist in `omnia`
* You the developer will be responsible for also copying any dependencies from `conda-forge` to `omnia` that you need and are not on the default channel

To copy packages:

**If you have write access to the `omnia` cloud**
1. **Open an Issue**
    * This is important so we can track changes made to the cloud in a public space
    * Note which package, version, and any dependencies you are bringing over
1. Get the [Anaconda CLI Tool](https://docs.continuum.io/anaconda-cloud/using#packages)
1. Copy the package [with the CLI](https://docs.continuum.io/anaconda-cloud/cli)
    * `anaconda copy conda-forge/{PACKAGE}/{VERSION} --to-owner omnia`
    * Replace `{PACKAGE}` and `{VERSION}` accordingly
1. Copy any dependencies you need in the same way
1. Close the issue

**If you do NOT have cloud write access**
1. Open an issue, request which package and dependencies
1. Request a maintainer who has cloud write access follow the steps above.

Eventually, all packages will be on `conda-forge` and we won't have to worry about the multiple channels any more, until
then, we thank you for your patience as we go through this transition.

### Supported versions

Python packages are built against latest two releases of python (3.5 and 3.6) and python 2.7.
Packages which have a binary dependency on [numpy](http://www.numpy.org/) are built against the latest two releases of numpy (1.10 and 1.11).

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
