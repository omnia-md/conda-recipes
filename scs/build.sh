#!/bin/bash
export BLAS_LAPACK_LIB_PATHS=$INCLUDE_PATH
export BLAS_LAPACK_LIBS=f2c:blas:lapack
$PYTHON setup.py install

