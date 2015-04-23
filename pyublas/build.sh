./configure.py --boost-inc-dir=$INCLUDE_PATH --boost-lib-dir=$LIBRARY_PATH
make
make install
python setup.py install
