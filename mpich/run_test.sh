#!/bin/bash

command -v mpichversion
mpichversion

command -v mpicc
mpicc -show

command -v mpicxx
mpicxx -show

command -v mpif90
mpif90 -show

command -v mpiexec

if [[ "$(uname)" == "Darwin" ]]; then
  MPIEXEC="mpiexec -launcher fork"
  $MPIEXEC --help
else
  # skip mpiexec tests on Linux due to conda-forge bug:
  # https://github.com/conda-forge/conda-smithy/pull/337
  MPIEXEC="echo SKIPPING mpiexec"
fi

pushd $RECIPE_DIR/tests

mpicc helloworld.c -o helloworld_c
$MPIEXEC -n 1 ./helloworld_c

mpicxx helloworld.cxx -o helloworld_cxx
$MPIEXEC -n 1 ./helloworld_cxx

mpif77 helloworld.f -o helloworld_f
$MPIEXEC -n 1 ./helloworld_f

mpif90 helloworld.f90 -o helloworld_f90
$MPIEXEC -n 1 ./helloworld_f90

popd