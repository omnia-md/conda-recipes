mingw32-make DYNAMIC_ARCH=1 BINARY=%ARCH% NO_LAPACK=0 NO_AFFINITY=1 NUM_THREADS=1 -j%CPU_COUNT%
mingw32-make install PREFIX=%PREFIX%
