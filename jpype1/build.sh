#!/bin/bash

s="import platform; import sys
from distutils.version import StrictVersion
curr = StrictVersion(platform.mac_ver()[0])
mavericks = StrictVersion('10.9')
if curr >= mavericks:
   sys.exit(0)
else:
   sys.exit(1)
"

# if on osx mavericks or higher link against new libstdc++
if `$PYTHON -c "$s"`; then
 echo "on mavericks or higher"
 export CFLAGS="-stdlib=libc++ -mmacosx-version-min=10.7"
fi

$PYTHON setup.py install
