#!/bin/bash

# on windows,
# return {'libraries': ['C:\\Miniconda\\lib\\libf2c', 'C:\\Miniconda\\lib\\blas', 'C:\\Miniconda\\lib\\lapack',]}


export LAPACK_INCLUDE_PATH=$LIBRARY_PATH
export LAPACK_LIB_PATH=$INCLUDE_PATH
export LAPACK_LIBS='f2c blas lapack'
$PYTHON setup.py install

