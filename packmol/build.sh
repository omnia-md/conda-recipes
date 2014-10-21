#!/bin/bash

# Required for cbio cluster for some stupid reason.
#export LD_LIBRARY_PATH=/opt/gnu/mpc/lib:/usr/local/cuda-5.5/targets/x86_64-linux/lib:/cbio/jclab/share/openmm/install/lib:/cbio/jclab/share/openmm/install/lib/plugins/:/usr/local/cuda-5.5/lib64:/opt/gnu/gcc/4.8.1/lib64:/opt/gnu/gcc/4.8.1/lib:/opt/gnu/gmp/lib:/opt/gnu/mpc/lib:/opt/gnu/mpfr/lib:/usr/local/cuda-5.5/lib64:/usr/local/cuda-5.5/lib:/usr/local/cuda-5.5/targets/x86_64-linux/lib/:/usr/local/cuda-5.5/targets/x86_64-linux/lib:/cbio/jclab/share/openmm/install/lib:/cbio/jclab/share/openmm/install/lib/plugins/:/usr/local/cuda-5.5/lib64:/opt/gnu/gcc/4.8.1/lib64:/opt/gnu/gcc/4.8.1/lib:/opt/gnu/gmp/lib:/opt/gnu/mpc/lib:/opt/gnu/mpfr/lib:/usr/local/cuda-5.5/lib64:/usr/local/cuda-5.5/lib:/usr/local/cuda-5.5/targets/x86_64-linux/lib/

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

# Build and install.
make

