IF "%ARCH%"=="32" (
    powershell -command "& { iwr ftp://ftp.fftw.org/pub/fftw/fftw-3.3.4-dll32.zip -OutFile fftw-3.3.4-dll32.zip }"
    7z e .\fftw-3.3.4-dll32.zip -offtw3
) ELSE (
    powershell -command "& { iwr ftp://ftp.fftw.org/pub/fftw/fftw-3.3.4-dll64.zip -OutFile fftw-3.3.4-dll64.zip }"
    7z e .\fftw-3.3.4-dll64.zip -offtw3
)

cd fftw3
lib /def:libfftw3-3.def
lib /def:libfftw3f-3.def
lib /def:libfftw3l-3.def
cd ..

ls fftw3
move fftw3\libfftw3-3.lib %LIBRARY_LIB%\
move fftw3\libfftw3f-3.lib %LIBRARY_LIB%\
move fftw3\libfftw3l-3.lib %LIBRARY_LIB%\
move fftw3\fftw3.h %LIBRARY_INC%\