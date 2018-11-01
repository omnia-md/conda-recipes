#!/bin/bash
echo "CUDA_VERSION: $CUDA_VERSION"
echo "PATH: $PATH"

set -e
set -x

conda config --add channels conda-forge
conda config --add channels omnia
conda config --add channels omnia/label/dev

#conda install -yq conda\<=4.3.34
#conda install -yq conda-build==2.1.17 jinja2 anaconda-client

# Enable gcc compiler toolchain
#source /opt/rh/devtoolset-2/enable
#export PATH=/opt/rh/devtoolset-2/root/usr/bin${PATH:+:${PATH}}
#export MANPATH=/opt/rh/devtoolset-2/root/usr/share/man:$MANPATH
#export INFOPATH=/opt/rh/devtoolset-2/root/usr/share/info${INFOPATH:+:${INFOPATH}}
#export PCP_DIR=/opt/rh/devtoolset-2/root
# Some perl Ext::MakeMaker versions install things under /usr/lib/perl5
# even though the system otherwise would go to /usr/lib64/perl5.
#export PERL5LIB=/opt/rh/devtoolset-2/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-2/root/usr/lib/perl5:/opt/rh/devtoolset-2/root//usr/share/perl5/vendor_perl${PERL5LIB:+:${PERL5LIB}}
# bz847911 workaround:
# we need to evaluate rpm's installed run-time % { _libdir }, not rpmbuild time
# or else /etc/ld.so.conf.d files?
#rpmlibdir=`rpm --eval "%{_libdir}"`
# bz1017604: On 64-bit hosts, we should include also the 32-bit library path.
#if [ "$rpmlibdir" != "${rpmlibdir/lib64/}" ]; then
#  rpmlibdir32=":/opt/rh/devtoolset-2/root${rpmlibdir/lib64/lib}"
#fi
#export LD_LIBRARY_PATH=/opt/rh/devtoolset-2/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# duplicate python site.py logic for sitepackages
#pythonvers=`python -c 'import sys; print sys.version[:3]'`
#export PYTHONPATH=/opt/rh/devtoolset-2/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-2/root/usr/lib/python$pythonvers/site-packages${PYTHONPATH:+:${PYTHONPATH}}

# Enable conda
#source /opt/docker/bin/entrypoint_source
#for PY_BUILD_VERSION in "27" "35" "36" "37"; do

# Make sure we have the appropriate channel added
conda config --add channels omnia/label/betacuda${CUDA_SHORT_VERSION};
conda config --add channels omnia/label/devcuda${CUDA_SHORT_VERSION};

for PY_BUILD_VERSION in "37" "36" "35" "27" ; do
    /io/conda-build-all -vvv --python $PY_BUILD_VERSION --check-against omnia/label/beta --check-against omnia/label/betacuda${CUDA_SHORT_VERSION} --check-against omnia/label/dev --check-against omnia/label/devcuda${CUDA_SHORT_VERSION} --numpy "1.15" $UPLOAD -- /io/*
done

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
