* Jenkins `osx` build: [![Jenkins `osx` build](https://jenkins.choderalab.org/job/conda-omnia-release-osx-2/badge/icon)](https://jenkins.choderalab.org/job/conda-omnia-release-osx-2/) [[console log]](https://jenkins.choderalab.org/job/conda-omnia-release-osx-2/lastBuild/consoleFull)
* Jenkins `linux` build: [![Jenkins `linux` build](https://jenkins.choderalab.org/job/conda-omnia-release-linux-vagrant/badge/icon)](https://jenkins.choderalab.org/job/conda-omnia-release-linux-vagrant/) [[console log]](https://jenkins.choderalab.org/job/conda-omnia-release-linux-vagrant/lastBuild/consoleFull)
* Appveyor-CI `windows` builds [![Appveyor Build status](https://ci.appveyor.com/api/projects/status/tsjbbgtobpbb4xps?svg=true)](https://ci.appveyor.com/project/rmcgibbo/conda-recipes)

omnia-md/conda-recipes
----------------------

The recipes here create conda packages for scientific and numerical software components associated with the Omnia project. The packages built from these recipes are shared with the community on [anaconda.org](https://anaconda.org/omnia).

To install a package
```
# Add the Omnia channel
$ conda config --add channels omnia

conda install mdtraj
```


### Supported versions

Python packages are built against latest two releases of python and python 2.7. Packages which have a binary dependency on Numpy are built against the latest two releases of Numpy.

### Building the packages

The recipes here are automatically built using [Appveyor-CI](http://www.appveyor.com/) and Jenkins. To build a package yourself, run `conda build <package_name>`, or `./conda-build-all ./*` to build multiple packages accross each of the supported Python/Numpy configurations.
