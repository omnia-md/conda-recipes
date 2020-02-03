:: Donwload fftw3.3.4 from fftw.org and the Visual Studio 2010 solution files
:: fftw-3.3-libs-visual-studio-2010.zip from http://www.fftw.org/install/windows.html
:: Open the solution file in Vsisual Studio, and compile the Static-Release target
:: for win32 and x64

set FFTW3_DIR=C:\Users\rmcgibbo\projects\fftw-3.3.4

IF "%ARCH%"=="32" (
    copy %FFTW3_DIR%\fftw-3.3-libs\Static-Release\libfftw-3.3.lib %LIBRARY_LIB%\
    copy %FFTW3_DIR%\fftw-3.3-libs\Static-Release\libfftwf-3.3.lib %LIBRARY_LIB%\
) ELSE (
    copy %FFTW3_DIR%\fftw-3.3-libs\x64\Static-Release\libfftw-3.3.lib %LIBRARY_LIB%\
    copy %FFTW3_DIR%\fftw-3.3-libs\x64\Static-Release\libfftwf-3.3.lib %LIBRARY_LIB%\
)

copy %FFTW3_DIR%\api\fftw3.h %LIBRARY_INC%\
