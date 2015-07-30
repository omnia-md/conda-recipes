:: Use python version to select which Visual Studio to use
:: For win-64, we'll need more, since those are separate compilers
:: Build in subdirectory.
mkdir build
cd build

cmake -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=%PREFIX% -DOPENMM_BUILD_PME_PLUGIN=ON -DFFTW_LIBRARY=%LIBRARY_LIB%\libfftwf-3.3.lib -DFFTW_INCLUDES=%LIBRARY_INC% -DCMAKE_BUILD_TYPE=Release ..

jom all DoxygenApiDocs :: sphinxpdf
jom install
if errorlevel 1 exit 1


set OPENMM_INCLUDE_PATH=%PREFIX%\include
set OPENMM_LIB_PATH=%PREFIX%\lib
cd python
%PYTHON% setup.py install
cd ..

:: Put examples into an appropriate subdirectory.
mkdir %PREFIX%\share\openmm
move %PREFIX%\examples %PREFIX%\share\openmm

:: Put docs into a subdirectory.
cd %PREFIX%\docs
mkdir openmm
move *.html openmm
:: move *.pdf openmm
:: move api-* openmm

if errorlevel 1 exit 1
