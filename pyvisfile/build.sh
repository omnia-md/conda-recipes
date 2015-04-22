
if [[ "$PY3K" == "1" ]]; then
  boost_python_libname="boost_python3"
  2to3 -w pyvisfile
else
    boost_python_libname="boost_python"
fi

./configure.py --silo-inc-dir=$PREFIX/include --silo-lib-dir=$PREFIX/lib --use-silo --boost-python-libname=$boost_python_libname
python setup.py install
