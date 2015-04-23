
if [[ "$PY3K" == "1" ]]; then
  boost_python_libname="boost_python3"
  2to3 -w pyvisfile
else
    boost_python_libname="boost_python"
fi

UBLAS_INCLUDE=`python -c 'import pyublas; import os; print(os.path.join(os.path.dirname(str(pyublas.__file__)), "include"))'`
NUMPY_INCLUDE=`python -c 'import numpy; print(numpy.get_include())'`
export CFLAGS="-I$UBLAS_INCLUDE -I${NUMPY_INCLUDE}"

./configure.py --silo-inc-dir=$PREFIX/include --silo-lib-dir=$PREFIX/lib --use-silo --boost-python-libname=$boost_python_libname
python setup.py install
