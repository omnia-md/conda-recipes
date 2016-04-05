#!/bin/bash
if [[ $OSTYPE -eq darwin* ]]; then
     export CFLAGS="-headerpad_max_install_names"
     export CXXFLAGS=$CFLAGS
fi
$PYTHON setup.py install
