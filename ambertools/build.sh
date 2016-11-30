#!/bin/sh

isosx=`python -c "import sys; print(sys.platform.startswith('darwin'))"`
if [ "$isosx" == "True" ]; then
    compiler='clang'
else
    compiler='gnu'
fi

export AMBERHOME=`pwd`
yes | ./configure -noX11 --with-python `which python` $compiler
source amber.sh

# build whole ambertools
# make install -j4

# build ambermini
source $RECIPE_DIR/build_ambermini.sh

# make test: add me

cp $AMBERHOME/bin/* $PREFIX/bin/
python $RECIPE_DIR/patch_amberhome/copy_and_post_process_bin.py
cp -rf $AMBERHOME/lib/* $PREFIX/lib/
cp -rf $AMBERHOME/include/* $PREFIX/include/
mkdir $PREFIX/dat/ && cp -rf $AMBERHOME/dat/* $PREFIX/dat/

# overwrite tleap, ...
# handle tleap a bit differently since it requires -I flag
# TODO: move to copy_and_post_process_bin.py?
cp $RECIPE_DIR/patch_amberhome/tleap $PREFIX/bin/
