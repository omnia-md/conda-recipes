mkdir build
cd build
cmake -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=%PREFIX% -DCMAKE_BUILD_TYPE=Release -Wno-dev ..
nmake 
nmake install