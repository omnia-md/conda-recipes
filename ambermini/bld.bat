python configure --yacc=bison --cc gcc.exe --cxx g++.exe --fc gfortran.exe --prefix %PREFIX%
mingw32-make
mingw32-make install
mv %PREFIX%\bin %PREFIX%\Scripts
