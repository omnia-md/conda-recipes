REM Get the path where mingw's libgfortran.a and libquadmath.a are stored

for /f "delims=" %%a in ('python %RECIPE_DIR%\libgfortranpath.py') do @set LIBGFORTRANPATH=%%a
echo %foobar%

REM Copy over the true static lib, libopenblaspy.a into the current directory,
REM and then link to it here. Otherwise, if we use the directory %LIBRARY_LIB%,
REM the linker will choose the import lib for the DLL.

xcopy %LIBRARY_LIB%\libopenblaspy.a .
set BLAS_LAPACK_LIB_PATHS=%LIBGFORTRANPATH%:.
set BLAS_LAPACK_LIBS=openblaspy:gfortran:quadmath

"%PYTHON%" setup.py build --compiler=mingw32 install
if errorlevel 1 exit 1
