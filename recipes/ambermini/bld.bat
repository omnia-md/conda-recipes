python configure --yacc=bison --cc gcc.exe --cxx g++.exe --fc gfortran.exe --prefix %PREFIX%
mingw32-make
mingw32-make install
xcopy /E %PREFIX%\bin %PREFIX%\Scripts\
if errorlevel 1 exit 1
