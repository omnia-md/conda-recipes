mkdir build
cd build

$PREFIX/bin/cmake \
    -DCMAKE_INSTALL_PREFIX:PATH="$PREFIX" \
    -DCMAKE_INSTALL_RPATH:STRING="$PREFIX" \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -Dbuild_wizard:BOOL=OFF \
    ..

make -j${CPU_COUNT}
make install

cp -v lib/* $PREFIX/lib/
