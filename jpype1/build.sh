#!/bin/bash

s="import platform; import sys
from distutils.version import StrictVersion
curr = StrictVersion(platform.mac_ver()[0])
yosemite = StrictVersion('10.10')
if curr >= yosemite:
   sys.exit(0)
else:
   sys.exit(1)
"

# if on osx yosemite or higher link against new libstdc++
if `$PYTHON -c "$s"`; then
 echo "on yosemite";
 CFLAGS="-stdlib=libstdc++"
fi

$PYTHON setup.py install
