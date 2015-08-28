mkdir %SCRIPTS%
copy swig.exe %SCRIPTS%\
mkdir %SCRIPTS%\Lib
xcopy /E Lib %SCRIPTS%\Lib\

if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.