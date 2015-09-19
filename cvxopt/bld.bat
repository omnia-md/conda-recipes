wget http://www.netlib.org/blas/blas.tgz
tar -xf blas.tgz
cd BLAS
sed 's/_LINUX/_WIN/' make.inc -i
mingw32-make && cp blas_WIN.a ../libblas.a
cd ..
if errorlevel 1 exit 1

wget http://www.netlib.org/lapack/lapack-3.4.0.tgz
tar -xf lapack-3.4.0.tgz
cd lapack-3.4.0
cp make.inc.example make.inc
mingw32-make lapacklib && cp liblapack.a ..
cd ..
if errorlevel 1 exit 1

cp libblas.a src/
cp liblapack.a src/

set CVXOPT_BLAS_EXTRA_LINK_ARGS=-lgfortran,-lquadmath
set CVXOPT_BLAS_LIB_DIR=.

%PYTHON% setup.py build --compiler=mingw32
%PYTHON% setup.py install
%PYTHON% examples/book/chap4/portfolio.py
if errorlevel 1 exit 1
