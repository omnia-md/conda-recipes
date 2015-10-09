export DYLD_LIBRARY_PATH=$PREFIX/lib:$DYLD_LIBRARY_PATH
./configure -fftw3 --with-netcdf=$PREFIX clang

unset DYLD_LIBRARY_PATH
make -j$CPU_COUNT install
cp -R bin/ $PREFIX/bin/
cp -R lib/ $PREFIX/lib/
