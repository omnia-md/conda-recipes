#!/bin/bash

$PYTHON setup.py clean
$PYTHON setup.py install

# Push examples to anaconda/share/bhmm/examples/
#mkdir $PREFIX/share/bhmm
#cp -r examples $PREFIX/share/bhmm/
