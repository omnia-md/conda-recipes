
set LAPACK_INCLUDE_PATH=%PREFIX%\include
set LAPACK_LIB_PATH=%PREFIX%\Lib
SET LAPACK_LIBS=%PREFIX%\Lib\libf2c %PREFIX%\Lib\blas %PREFIX%\Lib\lapack
echo %LAPACK_LIBS%

"%PYTHON%" setup.py install
if errorlevel 1 exit 1
