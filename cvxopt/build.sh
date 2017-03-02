#!/bin/bash


export BLAS_LAPACK_LIB_PATHS=$PREFIX/lib
export LDFLAGS=$(python libgfortranpath.py)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export CVXOPT_BLAS_LIB=openblas
    export CVXOPT_LAPACK_LIB=openblas
    export CVXOPT_BLAS_EXTRA_LINK_ARGS=-lgfortran,-lquadmath
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    export CVXOPT_BLAS_LIB=openblas
    export CVXOPT_LAPACK_LIB=openblas
    export CVXOPT_BLAS_EXTRA_LINK_ARGS=-lgfortran
fi

$PYTHON setup.py install
