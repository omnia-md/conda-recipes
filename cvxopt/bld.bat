for /f "delims=" %%a in ('python %RECIPE_DIR%\libgfortranpath.py') do @set LIBGFORTRANPATH=%%a

xcopy %LIBRARY_LIB%\libopenblaspy.a .
set CVXOPT_BLAS_LIB=openblaspy
set CVXOPT_LAPACK_LIB=openblaspy
set CVXOPT_BLAS_EXTRA_LINK_ARGS=-L%LIBGFORTRANPATH%,-lgfortran,-lquadmath
set CVXOPT_BLAS_LIB_DIR=.

%PYTHON% setup.py build --compiler=mingw32 install
%PYTHON% examples/book/chap4/portfolio.py
if errorlevel 1 exit 1
