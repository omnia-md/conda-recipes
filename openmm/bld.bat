:: Only python 3, since python2 uses VS2008,
:: which is not capable of compiling OpenMM
"%PYTHON%" -c "import sys; assert sys.version_info[0] == 3"
if errorlevel 1 exit 1

:: Build in subdirectory.
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=%PREFIX% ..
msbuild ALL_BUILD.vcxproj
msbuild INSTALL.vcxproj

set OPENMM_INCLUDE_PATH=%PREFIX%\include
set OPENMM_LIB_PATH=%PREFIX%\lib
cd python
%PYTHON% setup.py install
cd ..

:: Put examples into an appropriate subdirectory.
mkdir %PREFIX%\share\openmm
move %PREFIX%\examples %PREFIX%\share\openmm

if errorlevel 1 exit 1