# packmol

## Building Recipe

### Unix

Nothing special on unix, except that you must have gfortran installed.

### Windows

On windows, gfortran is expected to be found in C:\mingw64static\bin\gfortran.exe.
Use Carl Kleffner's static mingw64 toolchain, downloaded from https://bitbucket.org/carlkl/mingw-w64-for-python/downloads (specificially https://bitbucket.org/carlkl/mingw-w64-for-python/downloads/mingw64static-2014-07.7z)

Also, it's required that you have a bash interpreter and Make. Bash comes with Git for windows,
if you install all the unix tools. Make can be installed from GnuWin32 or using Chocolately
(https://chocolatey.org/)