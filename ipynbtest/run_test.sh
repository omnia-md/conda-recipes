#!/bin/sh
ipynbtest.py --eval "denom=0" --show-diff --timeout 2 --restart-if-fail 1 ../../examples/ipynbtest_tutorial.ipynb --tested-types "image/png, text/plain" --verbose --pylab
