./configure.py --boost-inc-dir=$PREFIX/include --boost-lib-dir=$PREFIX/lib
make
make install
python setup.py install
