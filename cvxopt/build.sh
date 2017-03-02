#!/bin/bash


export BLAS_LAPACK_LIB_PATHS=$PREFIX/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${PREFIX}/lib"
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
